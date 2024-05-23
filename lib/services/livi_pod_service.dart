import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/livi_pod.dart';
import '../models/models.dart';

class LiviPodService {
  final StreamController<List<LiviPod>> _liviPodStreamController =
      StreamController<List<LiviPod>>.broadcast();

  Future<List<LiviPod>> getLiviPods(/* accountId */) async {
    final List<LiviPod> liviPods = [];
    await FirebaseFirestore.instance
        .collection('livipods')
        //.where('accountId', isEqualTo: )
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        liviPods.addAll(querySnapshot.docs.map((snapshot) {
          var liviPod = LiviPod.fromJson(snapshot.data());
          liviPod.id = snapshot.id;
          return liviPod;
        }).toList());
      }
    });
    return Future.value(liviPods);
  }

  Future<LiviPod> addLiviPod(LiviPod liviPod) async {
    final json = await FirebaseFirestore.instance
        .collection('livipods')
        .add(liviPod.toJson());
    liviPod.id = json.id;
    return Future.value(liviPod);
  }

  Future updateLiviPod(LiviPod liviPod) async {
    try {
      final jsonMap = liviPod.toJson();
      final pod = await FirebaseFirestore.instance
          .collection('livipods')
          .where('remoteId', isEqualTo: liviPod.remoteId)
          .get()
          .then((querySnapshot) {
        return querySnapshot.docs[0].reference;
      });
      var batch = FirebaseFirestore.instance.batch();
      batch.update(pod, jsonMap);
      batch.commit();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return Future.value();
  }

  Future<void> removeLiviPod(LiviPod liviPod) async {
    await FirebaseFirestore.instance
        .collection('livipods')
        .doc(liviPod.id)
        .delete();
    return Future.value();
  }

  Future<bool> liviPodExists(LiviPod liviPod) async {
    var exists = false;
    await FirebaseFirestore.instance
        .collection('livipods')
        .where('remoteId', isEqualTo: liviPod.remoteId)
        .get()
        .then((querySnapshot) {
      exists = querySnapshot.size > 0;
    });
    return Future.value(exists);
  }

  Stream<List<LiviPod>> listenToLiviPodsRealTime(AppUser appUser) {
    FirebaseFirestore.instance
        .collection('livipods')
        .where('userId', isEqualTo: appUser.id)
        .snapshots()
        .listen(
            (liviPodsSnapshot) {
              if (liviPodsSnapshot.docs.isNotEmpty) {
                var liviPods = liviPodsSnapshot.docs.map((snapshot) {
                  var liviPod = LiviPod.fromJson(snapshot.data());
                  liviPod.id = snapshot.id;
                  return liviPod;
                }).toList();
                _liviPodStreamController.add(liviPods);
              }
            },
            cancelOnError: true,
            onError: (error) {
              if (kDebugMode) {
                print(error);
              }
            });
    return _liviPodStreamController.stream;
  }
}
