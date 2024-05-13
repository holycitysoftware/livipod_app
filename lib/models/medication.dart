import 'package:json_annotation/json_annotation.dart';
import '../utils/string_ext.dart';
import 'dosing.dart';
import 'enums.dart';
import 'schedule.dart';
import 'schedule_type.dart';
import '../utils/utils.dart' as utils;

part 'medication.g.dart';

@JsonSerializable(explicitToJson: true)
class Medication {
  @JsonKey(defaultValue: '')
  String id = '';
  String appUserId = '';
  String name = '';
  String manufacturer = '';
  DosageForm dosageForm = DosageForm.none;
  String packageId = '';
  String strength = '';
  String instructions = '';
  @JsonKey(name: 'schedules', defaultValue: <Schedule>[])
  List<Schedule> schedules = [];
  bool hasChanged = true;
  Dosing? nextDosing;
  Dosing? lastDosing;
  int inventoryQuantity = 30;
  ScheduleType type = ScheduleType.monthly;

  Medication({
    required this.name,
  });

  String getLastDosing() {
    if (lastDosing == null || lastDosing!.lastDosingTime == null) {
      return '-';
    }
    var offsetDosingTime = lastDosing!.lastDosingTime!.toLocal();
    return utils.getFormattedDateAndTime(offsetDosingTime);
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
    if (schedules.isNotEmpty && type == ScheduleType.asNeeded) {
      return 'as needed';
    }
    var offsetDosingTime = nextDosing!.scheduledDosingTime!.toLocal();
    return utils.getFormattedDateAndTime(offsetDosingTime);
  }

  List<String> getScheduleDescriptions() {
    var list = <String>[];
    for (var schedule in schedules) {
      list.add(schedule.getScheduleDescription(type));
    }
    return list;
  }

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationToJson(this);
}
