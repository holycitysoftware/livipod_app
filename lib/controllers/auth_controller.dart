import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../models/models.dart';
import '../utils/timezones.dart';

class AuthController extends ChangeNotifier {
  User? _user;
  String _verificationError = '';
  bool _promptForUserCode = false;
  String _verificationId = '';
  AppUser? _appUser;
  bool loading = false;

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
      firstName: fullNameController,
      email: emailController,
      useEmail: emailController != null && emailController.isNotEmpty,
      phoneNumber: phoneNumberController,
      timezone: timezone,
    );
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    clearVerificationError();
    loading = true;
    notifyListeners();
    _promptForUserCode = false;
    _verificationId = '';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // This handler will only be called on Android devices
        // which support automatic SMS code resolution.
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
        await _authenticate(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        _verificationError = e.message ?? e.code;
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
  }

  Future<void> _authenticate(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      // session-expired - use refresh token

      _verificationError = e.message ?? e.code;
      notifyListeners();
    }
  }

  Future<void> validate(String code) async {
    _promptForUserCode = false;
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: code);
    await _authenticate(credential);
  }

  Future<void> signOut() async {
    _appUser = null;
    FirebaseAuth.instance.signOut();
  }

  Future<void> refreshToken() async {}
}
