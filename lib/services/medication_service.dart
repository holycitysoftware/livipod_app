import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import 'medication_history.dart';

class MedicationService {
  final StreamController<List<Medication>> _medicationController =
      StreamController<List<Medication>>.broadcast();

  Future<Medication> createMedication(Medication medication) async {
    final json = await FirebaseFirestore.instance
        .collection('medications')
        .add(medication.toJson());
    medication.id = json.id;
    medication.hasChanged = true;
    return Future.value(medication);
  }

  Future<void> deleteMedication(Medication medication) async {
    await FirebaseFirestore.instance
        .collection('medications')
        .doc(medication.id)
        .delete();
    return Future.value();
  }

  Stream<List<Medication>> listenToMedicationsRealTime(
      AppUser authenticatedUser) {
    FirebaseFirestore.instance
        .collection('medications')
        .where('appUserId', isEqualTo: authenticatedUser.id)
        .snapshots()
        .listen(
            (medicationsSnapshot) {
              if (medicationsSnapshot.docs.isNotEmpty) {
                final medications = medicationsSnapshot.docs.map((snapshot) {
                  final medication = Medication.fromJson(snapshot.data());
                  medication.id = snapshot.id;
                  return medication;
                }).toList();
                _medicationController.add(medications);
              } else {
                _medicationController.add([]);
              }
            },
            cancelOnError: true,
            onError: (error) {
              if (kDebugMode) {
                print(error);
              }
            });
    return _medicationController.stream;
  }

  Future<void> updateMedication(Medication medication) async {
    medication.hasChanged = true;
    medication.nextDosing = null;
    final jsonMap = medication.toJson();
    await FirebaseFirestore.instance
        .collection('medications')
        .doc(medication.id)
        .update(jsonMap);
    return Future.value();
  }

  // This will be used when a caregiver wants to get a list of meds for one
  // of their patients
  Future<List<Medication>> getUserMedications(AppUser appUser) async {
    var medications = <Medication>[];
    try {
      await FirebaseFirestore.instance
          .collection('medications')
          .where('userId', isEqualTo: appUser.id)
          .get()
          .then((querySnapshot) {
        for (final result in querySnapshot.docs) {
          final medication = Medication.fromJson(result.data());
          medications.add(medication);
        }
      });

      return medications;
    } catch (e) {
      debugPrint('$e');
      return medications;
    }
  }

  Future<List<MedicationHistory>> getPatientMedicationHistory(
      AppUser patient, DateTime startDate, DateTime stopDate) async {
    var medicationHistory = <MedicationHistory>[];
    try {
      await FirebaseFirestore.instance
          .collection('medicationHistory')
          .where('userId', isEqualTo: patient.id)
          .where('dateTime', isLessThanOrEqualTo: stopDate.toIso8601String())
          .where('dateTime',
              isGreaterThanOrEqualTo: startDate.toIso8601String())
          .orderBy('dateTime', descending: true)
          .get()
          .then((querySnapshot) {
        for (final result in querySnapshot.docs) {
          final mh = MedicationHistory.fromJson(result.data());
          medicationHistory.add(mh);
        }
      });
      return medicationHistory;
    } catch (e) {
      debugPrint('$e');
      return medicationHistory;
    }
  }
}
