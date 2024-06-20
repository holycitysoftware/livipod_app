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
    if (nextDosing == null || nextDosing!.scheduledDosingTime == null) {
      return false;
    }

    final schedule = getCurrentSchedule();
    return now.isAfterIgnoringTimezone(nextDosing!.scheduledDosingTime!) &&
        now.isBeforeIgnoringTimezone(
          nextDosing!.scheduledDosingTime!.add(
            Duration(minutes: schedule.stopWarningMinutes ~/ 2),
          ),
        );
  }

  bool isLate() {
    final now = DateTime.now();
    if (nextDosing == null || nextDosing!.scheduledDosingTime == null) {
      return false;
    }

    final schedule = getCurrentSchedule();

    return now.isAfterIgnoringTimezone(
          nextDosing!.scheduledDosingTime!.add(
            Duration(minutes: schedules.first.stopWarningMinutes ~/ 2),
          ),
        ) &&
        now.isBeforeIgnoringTimezone(
          nextDosing!.scheduledDosingTime!.add(
            Duration(minutes: schedule.stopWarningMinutes),
          ),
        );
  }

  bool isAvailable() {
    final now = DateTime.now();
    if (nextDosing == null || nextDosing!.scheduledDosingTime == null) {
      return false;
    }
    final schedule = getCurrentSchedule();

    return now.isAfterIgnoringTimezone(
          nextDosing!.scheduledDosingTime!.subtract(
            Duration(minutes: schedule.startWarningMinutes),
          ),
        ) &&
        now.isBeforeIgnoringTimezone(nextDosing!.scheduledDosingTime!);
  }

  Schedule getCurrentSchedule() {
    Schedule? schedule;
    final now = DateTime.now();
    if (schedules.length > 1) {
      for (var i = 0; i < schedules.length; i++) {
        if (now.isAfterIgnoringTimezone(schedules[i].startDate) &&
            now.isBeforeIgnoringTimezone(schedules[i].endDate)) {
          schedule = schedules[i];
          break;
        }
      }
    }
    return schedule ?? schedules.first;
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
