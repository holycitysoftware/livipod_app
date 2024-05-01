import 'package:json_annotation/json_annotation.dart';
import 'dosing.dart';
import 'schedule.dart';
import 'schedule_type.dart';
import '../utils/utils.dart' as utils;

part 'medication.g.dart';

@JsonSerializable(explicitToJson: true)
class Medication {
  String id = '';
  String appUserId = '';
  String name = '';
  String manufacturer = '';
  String packageId = '';
  String instructions = '';
  @JsonKey(name: 'schedules', defaultValue: <Schedule>[])
  List<Schedule> schedules = [];
  bool hasChanged = true;
  Dosing? nextDosing;
  Dosing? lastDosing;

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

  List<String> getScheduleDescriptions() {
    var list = <String>[];
    for (var schedule in schedules) {
      list.add(schedule.getScheduleDescription());
    }
    return list;
  }

  factory Medication.fromJson(Map<String, dynamic> json) =>
      _$MedicationFromJson(json);

  Map<String, dynamic> toJson() => _$MedicationToJson(this);
}
