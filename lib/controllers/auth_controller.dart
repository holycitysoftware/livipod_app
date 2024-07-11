import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../models/models.dart';
import '../models/notification.dart';
import '../models/notification_type.dart';
import '../services/account_service.dart';
import '../services/app_user_service.dart';
import '../utils/logger.dart';
import '../utils/shared_prefs.dart';
import '../utils/string_ext.dart';
import '../utils/strings.dart';
import '../utils/utils.dart';

class AuthController extends ChangeNotifier {
  User? _user;
  String _verificationError = '';
  bool _promptForUserCode = false;
  String _verificationId = '';
  AppUser? _appUser;
  bool loading = false;
  int? resendToken;
  Set<PersonaOption> personaOptions = {};
  AppUserType? personaType;

  final _accountService = AccountService();
  final _appUserService = AppUserService();

  User? get firebaseAuthUser => _user;
  AppUser? get appUser => _appUser;
  String get verificationError => _verificationError;
  bool get promptForUserCode => _promptForUserCode;

  AuthController() {
    isFirstLogin();

    FirebaseAuth.instance.authStateChanges().listen(
        (user) async {
          _user = user;
          await getAppUser();
          notifyListeners();
        },
        cancelOnError: true,
        onDone: () {
          notifyListeners();
        },
        onError: (object) {
          if (kDebugMode) {
            print(object);
          }
          notifyListeners();
        });
  }

  void clearVerificationError() {
    _verificationError = '';
  }

  Future<void> isFirstLogin() async {
    final appCache = AppCache();
    final isFirstLogin = await appCache.getIsFirstLogin();
    if (isFirstLogin && FirebaseAuth.instance.currentUser != null) {
      signOut();
    }
    await appCache.cacheisFirstLogin(false);
  }

  Future<void> getAppUser() async {
    if (_user != null) {
      final user = await _appUserService.getUserByAuthId(_user!.uid);
      if (user != null) {
        _appUser = user;
      }
      notifyListeners();
    }
  }

  Future<void> editAppUser(AppUser user) async {
    await _appUserService.updateUser(user);
    notifyListeners();
  }

  Future<void> setAppUser(
      {required String fullNameController,
      String? emailController,
      required String phoneNumberController}) async {
    final timezone = await FlutterTimezone.getLocalTimezone();
    //Cache timezone?
    _appUser = AppUser(
      name: fullNameController,
      email: emailController,
      phoneNumber: phoneNumberController,
      timezone: timezone,
    );
  }

  void goBackBySettingPromptForUserCode() {
    _promptForUserCode = false;
    _appUser = null;
    notifyListeners();
  }

  Future<void> setPersona({
    AppUserType? personaType,
  }) async {
    personaType ??= calculatePersona();
    this.personaType = personaType;
  }

  Future<void> savePersona() async {
    if (_appUser != null && personaType != null) {
      _appUser!.appUserType = personaType!;
      await _appUserService.updateUser(_appUser!);
    }
  }

  AppUserType calculatePersona() {
    AppUserType personaType = AppUserType.selfGuidedUser;
    if (personaOptions.isNotEmpty) {
      if (personaOptions.first.appUserType == AppUserType.caredForUser ||
          personaOptions.first.appUserType == AppUserType.assistedUser) {
        personaType = AppUserType.assistedUser;
      }
      if (personaOptions.elementAt(1).appUserType == AppUserType.caredForUser ||
          personaOptions.elementAt(1).appUserType == AppUserType.assistedUser) {
        personaType = AppUserType.assistedUser;
      }
      if (personaOptions.elementAt(2).appUserType == AppUserType.caredForUser ||
          personaOptions.elementAt(2).appUserType == AppUserType.assistedUser) {
        personaType = AppUserType.assistedUser;
      }
      if (personaOptions.elementAt(3).appUserType == AppUserType.caredForUser) {
        personaType = AppUserType.assistedUser;
      }
      if (personaOptions.elementAt(4).appUserType == AppUserType.caredForUser ||
          personaOptions.elementAt(4).appUserType == AppUserType.assistedUser) {
        personaType = AppUserType.assistedUser;
      }
      if (personaOptions.elementAt(5).appUserType == AppUserType.caredForUser ||
          personaOptions.elementAt(5).appUserType == AppUserType.assistedUser) {
        personaType = AppUserType.assistedUser;
      }
      if (personaOptions.elementAt(6).appUserType == AppUserType.caredForUser) {
        personaType = AppUserType.assistedUser;
      }
      if (personaOptions.elementAt(7).appUserType == AppUserType.assistedUser) {
        personaType = AppUserType.assistedUser;
      }
      if (personaOptions.elementAt(7).appUserType == AppUserType.caredForUser) {
        personaType = AppUserType.caredForUser;
      }
    }
    return personaType;
  }

  Future<void> verifyPhoneNumber(String phoneNumber,
      {bool isAccountCreation = false}) async {
    try {
      clearVerificationError();
      loading = true;
      notifyListeners();
      _promptForUserCode = false;
      _verificationId = '';

      if ((validatePhone(phoneNumber) ?? '').isNotEmpty) {
        throw Exception(Strings.invalidPhoneNumber);
      }

      final phoneNumberIsRegistered =
          await AppUserService().phoneNumberExists(appUser, phoneNumber);
      if (!phoneNumberIsRegistered && !isAccountCreation) {
        throw Exception(Strings.noUsersPhoneNumber);
      } else if (phoneNumberIsRegistered && isAccountCreation) {
        throw Exception(Strings.phoneNumberExists);
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            // This handler will only be called on Android devices
            // which support automatic SMS code resolution.
            // ANDROID ONLY!
            // Sign the user in (or link) with the auto-generated credential
            await _authenticate(credential);
          } catch (e, s) {
            _verificationError = e.toString();
            await signOut();
            logger(e.toString());
            logger(s.toString());
            notifyListeners();
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.message == 'TOO_LONG' || e.code == 'TOO_LONG') {
            _verificationError = 'The phone number is too long.';
          }
          if (e.message == 'TOO_SHORT' || e.code == 'TOO_SHORT') {
            _verificationError = 'The phone number is too short.';
          } else {
            _verificationError = e.message ?? e.code;
          }
          _promptForUserCode = false;
          _verificationId = '';
          loading = false;
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _promptForUserCode = true;
          loading = false;
          resendToken = resendToken;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          /*
          On Android devices which support automatic SMS code resolution, 
          this handler will be called if the device has not automatically 
          resolved an SMS message within a certain timeframe. 
          Once the timeframe has passed, the device will no longer attempt 
          to resolve any incoming messages.

          By default, the device waits for 30 seconds however this can be 
          customized with the timeout argument:
        */
          _verificationError = 'Auto-resolution has timed out.';
          loading = false;
          notifyListeners();
        },
      );
    } catch (e, s) {
      _verificationError = e.toString().removeExceptionString();
      loading = false;
      _promptForUserCode = false;
      logger(e.toString());
      logger(s.toString());
      notifyListeners();
    }
  }

  Future<UserCredential?> _authenticate(
    PhoneAuthCredential credential, {
    bool isAccountCreation = false,
  }) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // session-expired - use refresh token

      _verificationError = e.message ?? e.code;
      await getAppUser();
      notifyListeners();

      return null;
    } on Exception catch (e, s) {
      _verificationError = e.toString().removeExceptionString();
      await signOut();
      notifyListeners();
      logger(e.toString());
      logger(s.toString());
      return null;
    }
  }

  Future<void> setLoading(bool value) async {
    loading = value;
    notifyListeners();
  }

  Future<void> createUser(UserCredential userCredential) async {
    try {
      //Check if user already exists
      if (userCredential != null && userCredential.user != null) {
        final user =
            await _appUserService.getUserByAuthId(userCredential.user!.uid);
        if (user != null) {
          throw Exception('User already exists.');
        }
      }
      if (userCredential.user != null) {
        // STEP 1: CREATE ACCOUNT SHELL
        final account = await _accountService.createAccount(
          Account(), // create account shell
        );
        try {
          // STEP 2: CREATE USER
          final user = await _appUserService.createUser(_appUser!);
          user.language = Platform.localeName.split('_').first;
          user.authId =
              userCredential.user!.uid; // security link to Firebase Auth
          user.notifications = createNotifications();

          // STEP 3: ASSOCIATE OWNER
          account.ownerId = user.id;
          await _accountService.updateAccount(account); // associated new owner

          // STEP 4: ASSOCIATE ACCOUNT
          user.accountId = account.id;
          await _appUserService.updateUser(user);
          _appUser = user;
        } catch (e) {
          await _accountService.deleteAccount(account);
          _promptForUserCode = false;
          _verificationError = e.toString().removeExceptionString();
          await signOut();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> validate(
    String code, {
    bool isAccountCreation = false,
  }) async {
    try {
      await setLoading(true);

      // Create a PhoneAuthCredential with the code
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code);
      final UserCredential? userCredential =
          await _authenticate(credential, isAccountCreation: isAccountCreation);
      if (isAccountCreation && userCredential != null) {
        await createUser(userCredential);
      }
      if (userCredential != null &&
          userCredential.user != null &&
          !isAccountCreation) {
        await getAppUser();
      }
      _promptForUserCode = false;

      await setLoading(false);
    } catch (e, s) {
      _verificationError = e.toString().removeExceptionString();
      await signOut();
      _promptForUserCode = false;
      await setLoading(false);
      notifyListeners();
      logger(e.toString());
      logger(s.toString());
    }
  }

  Future<void> signOut() async {
    _appUser = null;
    await FirebaseAuth.instance.signOut();
    clearVerificationError();
  }

  List<Notification> createNotifications() {
    return [
      Notification(notificationType: NotificationType.medicationTaken),
      Notification(notificationType: NotificationType.medicationAvailable),
      Notification(notificationType: NotificationType.medicationLate),
      Notification(notificationType: NotificationType.medicationDue),
      Notification(notificationType: NotificationType.medicationMissed),
      Notification(notificationType: NotificationType.inventoryLow),
      Notification(notificationType: NotificationType.inventoryEmpty),
      Notification(notificationType: NotificationType.wifiUnavailable),
    ];
  }

  Future<void> refreshToken() async {}
}
