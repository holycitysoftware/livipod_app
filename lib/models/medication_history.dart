import 'package:json_annotation/json_annotation.dart';

import '../utils/string_ext.dart';
import 'enums.dart';
import 'models.dart';
import 'schedule_type.dart';

part 'medication_history.g.dart';

@JsonSerializable(explicitToJson: true)
class MedicationHistory {
  String? id = '';
  String accountId = '';
  DateTime dateTime;
  String name = '';
  DosageForm? dosageForm = DosageForm.none;
  String medicationId = '';
  String? strength = '';
  bool? isOverride = false;
  String medicationName = '';
  int? inventoryQuantity = 0;
  ScheduleType? scheduleType;
  String? schedules = '';
  DosingOutcome? outcome = DosingOutcome.missed;
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
    history.dosageForm = med.dosageForm;
    history.strength = med.strength;
    history.scheduleType = med.schedules.first.type;
    history.inventoryQuantity = med.inventoryQuantity;
    history.schedules = '';
    med.schedules.forEach((schedule) {
      history.schedules =
          '${history.schedules!} ${schedule.getScheduleDescription(appUser.useMilitaryTime)}';
    });
    if (med.lastDosing != null) {
      history.qtyDispensed = med.lastDosing!.qtyDispensed;
      history.outcome = med.lastDosing!.outcome;
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

  String getNameStrengthDosageForm() {
    final name = medicationName.capitalizeFirstLetter();
    if (strength != null) {
      medicationName = '$medicationName $strength';
    }
    if (dosageForm != null && dosageForm != DosageForm.none) {
      medicationName =
          '$medicationName ${dosageForm!.description.capitalizeFirstLetter()}';
    }
    return medicationName;
  }

  Map<String, dynamic> toJson() => _$MedicationHistoryToJson(this);
}
