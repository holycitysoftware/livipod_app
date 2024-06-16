import 'package:json_annotation/json_annotation.dart';

import 'dosing.dart';

part 'medication_history.g.dart';

@JsonSerializable(explicitToJson: true)
class MedicationHistory {
  String accountId = '';
  DateTime dateTime;
  String drugDatabaseId = '';
  String firstName = '';
  String lastName = '';
  String medicationId = '';
  String medicationName = '';
  DosingOutcome outcome = DosingOutcome.missed;
  String patientId = '';
  double qtyDispensed = 0.0;
  double qtyMissed = 0.0;
  double qtyRemaining = 0.0;
  double qtyRequested = 0.0;
  double qtySkipped = 0.0;
  DateTime? scheduledDosingTime;
  String userId = '';

  MedicationHistory({required this.dateTime});

  factory MedicationHistory.fromJson(Map<String, dynamic> json) =>
      _$MedicationHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationHistoryToJson(this);
}
