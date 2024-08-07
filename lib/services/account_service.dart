import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/account.dart';
import '../models/app_user.dart';

class AccountService {
  final StreamController<List<Account>> _accountsController =
      StreamController<List<Account>>.broadcast();

  AccountService();

  Future<Account> createAccount(Account account) async {
    final json = await FirebaseFirestore.instance
        .collection('accounts')
        .add(account.toJson());
    account.id = json.id;
    return Future.value(account);
  }

  Future<AppUser?> getOwner(Account account) async {
    AppUser? user;
    await FirebaseFirestore.instance.collection('users').get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        user = AppUser.fromJson(snapshot.docs[0].data());
      }
    });
    return Future.value(user);
  }

  Future<Account?> getAccount(Account account) async {
    await FirebaseFirestore.instance
        .collection('accounts')
        .where('ownerId', isEqualTo: account.ownerId)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        account = Account.fromJson(snapshot.docs[0].data());
      }
    });
    return Future.value(account);
  }

  Future deleteAccount(Account account) async {
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc(account.id)
        .delete();
  }

  Future updateAccount(Account account) async {
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc(account.id)
        .update(account.toJson());
  }

  Stream<List<Account>> listenToAccountsRealTime() {
    FirebaseFirestore.instance.collection('accounts').snapshots().listen(
        (accountsSnapshot) {
          if (accountsSnapshot.docs.isNotEmpty) {
            var accounts = accountsSnapshot.docs.map((snapshot) {
              var account = Account.fromJson(snapshot.data());
              account.id = snapshot.id;
              return account;
            }).toList();
            _accountsController.add(accounts);
          }
        },
        cancelOnError: true,
        onError: (error) {
          if (kDebugMode) {
            print(error);
          }
        });
    return _accountsController.stream;
  }
}
