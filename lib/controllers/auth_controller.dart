import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:uuid/uuid.dart';

import '../models/models.dart';
import '../services/account_service.dart';
import '../services/app_user_service.dart';
import '../utils/logger.dart';
import '../utils/string_ext.dart';

class AuthController extends ChangeNotifier {
  User? _user;
  String _verificationError = '';
  bool _promptForUserCode = false;
  String _verificationId = '';
  AppUser? _appUser;
  bool loading = false;

  final _accountService = AccountService();
  final _appUserService = AppUserService();

  User? get firebaseAuthUser => _user;
  AppUser? get appUser => _appUser;
  String get verificationError => _verificationError;
  bool get promptForUserCode => _promptForUserCode;

  AuthController() {
    FirebaseAuth.instance.authStateChanges().listen(
        (user) {
          _user = user;
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

  Future<void> setAppUser(
      {required String fullNameController,
      String? emailController,
      required String phoneNumberController}) async {
    final timezone = await FlutterTimezone.getLocalTimezone();
    //Cache timezone?
    _appUser = AppUser(
      name: fullNameController,
      email: emailController,
      useEmail: emailController != null && emailController.isNotEmpty,
      phoneNumber: phoneNumberController,
      timezone: timezone,
    );
  }

  Future<void> verifyPhoneNumber(String phoneNumber,
      {bool isAccountCreation = false}) async {
    try {
      clearVerificationError();
      loading = true;
      notifyListeners();
      _promptForUserCode = false;
      _verificationId = '';

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            // This handler will only be called on Android devices
            // which support automatic SMS code resolution.
            // ANDROID ONLY!
            // Sign the user in (or link) with the auto-generated credential
            await _authenticate(credential);
          } catch (e, s) {
            _verificationError = e.toString();
            signOut();
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
      notifyListeners();
      return null;
    } on Exception catch (e, s) {
      _verificationError = e.toString().removeExceptionString();
      signOut();
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
      final accountUuid = Uuid().v4();

      //Check if user already exists
      if (userCredential != null && userCredential.user != null) {
        final user =
            await _appUserService.getUserById(userCredential.user!.uid);
        if (user != null) {
          throw Exception('User already exists.');
        }
      }
      if (userCredential.user != null) {
        _appUser!.id = userCredential.user!.uid;
        _appUser!.accountId = accountUuid;

        final account = await _accountService.createAccount(
          Account(
            id: accountUuid,
            ownerId: _appUser!.id,
          ),
        );

        if (_appUser != null) {
          try {
            await _appUserService.createUser(_appUser!);
          } catch (e) {
            _accountService.deleteAccount(account);
            _promptForUserCode = false;
            _verificationError = e.toString().removeExceptionString();
            ;
            signOut();
          }
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
      setLoading(true);

      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: code);
      final UserCredential? userCredential =
          await _authenticate(credential, isAccountCreation: isAccountCreation);
      if (isAccountCreation && userCredential != null) {
        await createUser(userCredential);
      }
      if (userCredential != null &&
          userCredential.user != null &&
          !isAccountCreation) {
        _appUser = await _appUserService.getUserById(userCredential.user!.uid);
        notifyListeners();
      }
      _promptForUserCode = false;

      setLoading(false);
    } catch (e, s) {
      _verificationError = e.toString().removeExceptionString();
      signOut();
      setLoading(false);
      notifyListeners();
      logger(e.toString());
      logger(s.toString());
    }
  }

  Future<void> signOut() async {
    _appUser = null;
    FirebaseAuth.instance.signOut();
  }

  Future<void> refreshToken() async {}
}
