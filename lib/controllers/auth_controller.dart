import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:livipod_app/models/app_user.dart';

class AuthController extends ChangeNotifier {
  User? _user;
  String _verificationError = '';
  bool _promptForUserCode = false;
  String _verificationId = '';

  User? get firebaseAuthUser => _user;
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

  Future<void> verifyPhoneNumber(AppUser appUser) async {
    _verificationId = '';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: appUser.mobile,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // This handler will only be called on Android devices
        // which support automatic SMS code resolution.
        // ANDROID ONLY!
        // Sign the user in (or link) with the auto-generated credential
        await _authenticate(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        _verificationError = e.message ?? e.code;
        notifyListeners();
      },
      codeSent: (String verificationId, int? resendToken) {
        _promptForUserCode = true;
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
        notifyListeners();
      },
    );
  }

  Future<void> _authenticate(PhoneAuthCredential credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> validate(String code) async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: code);
    await _authenticate(credential);
  }
}
