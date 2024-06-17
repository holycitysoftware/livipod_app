import 'package:json_annotation/json_annotation.dart';

import '../utils/string_ext.dart';
import '../utils/strings.dart';
import '../utils/utils.dart' as utils;
import 'dosing.dart';
import 'enums.dart';
import 'schedule.dart';
import 'schedule_type.dart';

part 'medication.g.dart';

@JsonSerializable(explicitToJson: true)
class Medication {
  @JsonKey(includeFromJson: false, includeToJson: false)
  String id = '';
  String appUserId = '';
  String name = '';
  String manufacturer = '';
  DosageForm dosageForm = DosageForm.none;
  int inventoryQuantity = 30;
  String packageId = '';
  String strength = '';
  String instructions = '';
  @JsonKey(name: 'schedules', defaultValue: <Schedule>[])
  List<Schedule> schedules = [];
  bool hasChanged = true;
  Dosing? nextDosing;
  Dosing? lastDosing;
  bool enabled = true;

  Medication({
    required this.name,
  });

  bool isAsNeeded() {
    return schedules.isNotEmpty && schedules[0].type == ScheduleType.asNeeded;
  }

  bool isDue() {
    final now = DateTime.now();
    if (nextDosing != null) {
      var differenceMinutes =
          nextDosing!.scheduledDosingTime!.difference(now).inMinutes;
      if (differenceMinutes < 0) {
        differenceMinutes = differenceMinutes * -1;
      }
      return nextDosing != null &&
          nextDosing!.scheduledDosingTime != null &&
          differenceMinutes < 6;
    }
    return false;
  }

  String getLastDosing() {
    if (lastDosing == null || lastDosing!.lastDosingTime == null) {
      return '-';
    }
    var offsetDosingTime = lastDosing!.lastDosingTime!.toLocal();
    return utils.getFormattedDateAndTime(offsetDosingTime);
  }

  String dosageFormStrengthType() {
    var dosageFormStrength = '';
    if (dosageForm != DosageForm.none) {
      dosageFormStrength = dosageForm.description.capitalizeFirstLetter();
    }
    if (strength.isNotEmpty) {
      dosageFormStrength = '$dosageFormStrength $strength';
    }
    dosageFormStrength =
        '$dosageFormStrength ${schedules[0].type.description.capitalizeFirstLetter()}';
    return dosageFormStrength;
  }

  String getNameStrengthDosageForm() {
    var name = this.name.capitalizeFirstLetter();
    if (strength.isNotEmpty) {
      name = '$name $strength';
    }
    if (dosageForm != DosageForm.none) {
      name = '$name ${dosageForm.description.capitalizeFirstLetter()}';
    }
    return name;
  }

  String getNextDosing() {
    if (nextDosing == null) {
      return '-';
    }
    if (schedules.isNotEmpty && schedules[0].type == ScheduleType.asNeeded) {
      return 'as needed';
    }
    var offsetDosingTime = nextDosing!.scheduledDosingTime!.toLocal();
    return utils.getFormattedDateAndTime(offsetDosingTime);
  }

  String getNextDosingDescription() {
    if (nextDosing == null) {
      return '-';
    }
    if (schedules.isNotEmpty && schedules[0].type == ScheduleType.asNeeded) {
      return 'as needed';
    }
    var offsetDosingTime = nextDosing!.scheduledDosingTime!.toLocal();
    return '${Strings.take} ${nextDosing!.qtyRequested.toInt()} ${Strings.at} ${utils.getFormattedTime(offsetDosingTime)}';
  }

  List<String> getScheduleDescriptions() {
    var list = <String>[];
    for (var schedule in schedules) {
      list.add(schedule.getScheduleDescription());
    }
    return list;
  }

  String getMedicationInfo() {
    return '$name $strength $dosageForm';
  }

  // @override
  // bool operator ==(dynamic other) => id == other.id;

  // @override
  // int get hashCode => super.hashCode;

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationToJson(this);
}
