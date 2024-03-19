import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/account.dart';
import '../models/app_user.dart';

class AccountService extends ChangeNotifier {
  final StreamController<List<Account>> _accountsController =
      StreamController<List<Account>>.broadcast();

  AccountService();

  Future<Account> createAccount(Account account) async {
    var json = await FirebaseFirestore.instance
        .collection('accounts')
        .add(account.toJson());
    account.id = json.id;
    return Future.value(account);
  }

  Future<AppUser?> getOwner(Account account) async {
    AppUser? user;
    await FirebaseFirestore.instance
        .collection('users')
        .where('accountId', isEqualTo: account.id)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        user = AppUser.fromJson(snapshot.docs[0].data());
      }
    });
    return Future.value(user);
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
