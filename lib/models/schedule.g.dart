// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      endDate: DateTime.parse(json['endDate'] as String),
      startDate: DateTime.parse(json['startDate'] as String),
      scheduledDosings:
          Schedule.scheduledDosingsFromJson(json['scheduledDosings'] as List),
      prnDosing: json['prnDosing'] == null
          ? null
          : PrnDose.fromJson(json['prnDosing'] as Map<String, dynamic>),
    )
      ..type = $enumDecode(_$ScheduleTypeEnumMap, json['type'])
      ..frequency =
          (json['frequency'] as List<dynamic>).map((e) => e as int).toList()
      ..dayPattern =
          (json['dayPattern'] as List<dynamic>).map((e) => e as int).toList()
      ..monthPattern =
          (json['monthPattern'] as List<dynamic>).map((e) => e as int).toList()
      ..startWarningMinutes = json['startWarningMinutes'] as int
      ..stopWarningMinutes = json['stopWarningMinutes'] as int;

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'startDate': Schedule.startDateToJson(instance.startDate),
      'endDate': Schedule.endDateToJson(instance.endDate),
      'type': _$ScheduleTypeEnumMap[instance.type]!,
      'frequency': instance.frequency,
      'dayPattern': instance.dayPattern,
      'monthPattern': instance.monthPattern,
      'scheduledDosings':
          instance.scheduledDosings.map((e) => e.toJson()).toList(),
      'prnDosing': instance.prnDosing?.toJson(),
      'startWarningMinutes': instance.startWarningMinutes,
      'stopWarningMinutes': instance.stopWarningMinutes,
    };

const _$ScheduleTypeEnumMap = {
  ScheduleType.asNeeded: 'asNeeded',
  ScheduleType.daily: 'daily',
  ScheduleType.weekly: 'weekly',
  ScheduleType.monthly: 'monthly',
};
