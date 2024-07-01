import 'package:json_annotation/json_annotation.dart';

import 'models.dart';

part 'medication_history.g.dart';

@JsonSerializable(explicitToJson: true)
class MedicationHistory {
  String accountId = '';
  DateTime dateTime;
  String name = '';
  String medicationId = '';
  String medicationName = '';
  DosingOutcome outcome = DosingOutcome.missed;
  double qtyDispensed = 0.0;
  double qtyMissed = 0.0;
  double qtyRemaining = 0.0;
  double qtyRequested = 0.0;
  double qtySkipped = 0.0;
  DateTime? scheduledDosingTime;
  String appUserId = '';

  MedicationHistory({required this.dateTime});

  factory MedicationHistory.fromJson(Map<String, dynamic> json) =>
      _$MedicationHistoryFromJson(json);

  ///create medication history by passing a medication and a dosing
  static MedicationHistory createMedicationHistory(
      Medication med, AppUser appUser) {
    final history = MedicationHistory(
      dateTime: DateTime.now(),
    );

    history.accountId = appUser.accountId;
    history.name = appUser.name;
    history.medicationId = med.id;
    history.medicationName = med.name;
    if (med.lastDosing != null) {
      history.qtyDispensed = med.lastDosing!.qtyDispensed;
      history.outcome = med.lastDosing!.outcome!;
      history.qtyMissed = med.lastDosing!.qtyMissed;
      history.qtyRemaining = med.lastDosing!.qtyRemaining;
      history.qtyRequested = med.lastDosing!.qtyRequested;
      history.dateTime = med.lastDosing!.scheduledDosingTime!;
      history.qtySkipped = med.lastDosing!.qtySkipped;
      history.scheduledDosingTime = med.lastDosing!.scheduledDosingTime;
    }
    history.appUserId = appUser.id;
    return history;
  }

  Map<String, dynamic> toJson() => _$MedicationHistoryToJson(this);
}
