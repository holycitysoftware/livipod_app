import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/models.dart';

class AppUserService {
  AppUser? _appUser;
  List<AppUser> _appUsers = [];

  final StreamController<List<AppUser>> _accountUsersController =
      StreamController<List<AppUser>>.broadcast();

  final StreamController<AppUser> _userController =
      StreamController<AppUser>.broadcast();

  AppUser? get appUser => _appUser;
  List<AppUser> get appUsers => _appUsers;

  Future<AppUser> createUser(AppUser user) async {
    try {
      final json = await FirebaseFirestore.instance
          .collection('users')
          .add(user.toJson());
      user.id = json.id;
      return Future.value(user);
    } catch (e) {
      throw Exception('Error creating a user');
    }
  }

  Future<void> updateUser(AppUser user) async {
    final jsonMap = user.toJson();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update(jsonMap);
    return Future.value();
  }

  Future deleteUser(AppUser user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.id).delete();
  }

  Future<Account?> getAccountFor(AppUser user) async {
    Account? account;
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc(user.accountId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        account = Account.fromJson(snapshot.data()!);
      }
    });
    return Future.value(account);
  }

  Future updateUsersFor(Account account) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('accountId', isEqualTo: account.id)
        .get()
        .then((snapshot) async {
      for (final doc in snapshot.docs) {
        final user = AppUser.fromJson(doc.data());
        user.enabled = account.enabled;
        await updateUser(user);
      }
    });
  }

  Future<AppUser?> getUserById(String userId) async {
    AppUser? user;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: userId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          user = AppUser.fromJson(querySnapshot.docs[0].data());
        }
      });
    } catch (e) {
      debugPrint('$e');
    }
    return Future.value(user);
  }

  Future<AppUser?> getUserByAuthId(String authId) async {
    AppUser? user;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('authId', isEqualTo: authId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          user = AppUser.fromJson(querySnapshot.docs[0].data());
        }
      });
    } catch (e) {
      debugPrint('$e');
    }
    return Future.value(user);
  }

  Future<AppUser> getAccountOwner(Account account) async {
    AppUser? user;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: account.ownerId)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          user = AppUser.fromJson(querySnapshot.docs[0].data());
        }
      });
    } catch (e) {
      debugPrint('$e');
    }
    return Future.value(user);
  }

  Stream<List<AppUser>> listenToUsersRealTime(AppUser authenticatedUser) {
    FirebaseFirestore.instance
        .collection('users')
        .where('accountId', isEqualTo: authenticatedUser.accountId)
        .snapshots()
        .listen(
            (usersSnapshot) {
              if (usersSnapshot.docs.isNotEmpty) {
                final users = usersSnapshot.docs.map((snapshot) {
                  final user = AppUser.fromJson(snapshot.data());
                  user.id = snapshot.id;
                  return user;
                }).toList();
                _accountUsersController.add(users);
              }
            },
            cancelOnError: true,
            onError: (error) {
              if (kDebugMode) {
                print(error);
              }
            });
    return _accountUsersController.stream;
  }

  Future<bool> phoneNumberExists(AppUser? currentUser, String mobile) async {
    bool exists = true;
    await FirebaseFirestore.instance
        .collection('users')
        .where('mobile', isEqualTo: mobile)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        exists = false;
      }
      for (final result in querySnapshot.docs) {
        exists = result.id != currentUser?.id;
      }
    }).catchError((error) {
      exists = true;
    });
    return Future.value(exists);
  }

  Future<List<AppUser>> getAvailableCaregivers(AppUser appUser) async {
    List<AppUser> users = [];
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where('accountId', isEqualTo: appUser.accountId)
          .get()
          .then((querySnapshot) {
        for (final result in querySnapshot.docs) {
          final user = AppUser.fromJson(result.data());
          if (user.id != appUser.id &&
              user.appUserType == AppUserType.caregiver) {
            user.id = result.id;
            users.add(user);
          }
        }
      });

      users.sort((a, b) => a.name.compareTo(b.name));
      return users;
    } catch (e) {
      debugPrint('$e');
      return users;
    }
  }

  Stream<AppUser> listenToUserRealTime(AppUser user) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .snapshots()
        .listen(
            (userSnapshot) {
              if (userSnapshot.exists) {
                final user = AppUser.fromJson(userSnapshot.data()!);
                user.id = userSnapshot.id;
                _userController.add(user);
              }
            },
            cancelOnError: true,
            onError: (error) {
              if (kDebugMode) {
                print(error);
              }
            });
    return _userController.stream;
  }
}
