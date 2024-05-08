// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      type: $enumDecodeNullable(_$ScheduleTypeEnumMap, json['type']) ??
          ScheduleType.daily,
      timeReminderBefore: $enumDecodeNullable(
              _$TimeReminderBeforeEnumMap, json['timeReminderBefore']) ??
          TimeReminderBefore.fiveMinutes,
      timeReminderLater: $enumDecodeNullable(
              _$TimeReminderLaterEnumMap, json['timeReminderLater']) ??
          TimeReminderLater.fiveMinutes,
      intervalBetweenDoses: $enumDecodeNullable(
              _$IntervalBetweenDosesEnumMap, json['intervalBetweenDoses']) ??
          IntervalBetweenDoses.eightHours,
      instructions: json['instructions'] as String? ?? '',
      frequency: json['frequency'] as int? ?? 1,
      dayPattern: (json['dayPattern'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      monthPattern: (json['monthPattern'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          const [],
      scheduledDosings: (json['scheduledDosings'] as List<dynamic>?)
              ?.map((e) => ScheduledDose.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      prnDosing: json['prnDosing'] == null
          ? null
          : PrnDose.fromJson(json['prnDosing'] as Map<String, dynamic>),
    )..startDate = DateTime.parse(json['startDate'] as String);

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'type': _$ScheduleTypeEnumMap[instance.type]!,
      'intervalBetweenDoses':
          _$IntervalBetweenDosesEnumMap[instance.intervalBetweenDoses]!,
      'frequency': instance.frequency,
      'dayPattern': instance.dayPattern,
      'monthPattern': instance.monthPattern,
      'scheduledDosings':
          instance.scheduledDosings.map((e) => e.toJson()).toList(),
      'prnDosing': instance.prnDosing?.toJson(),
      'timeReminderLater':
          _$TimeReminderLaterEnumMap[instance.timeReminderLater]!,
      'timeReminderBefore':
          _$TimeReminderBeforeEnumMap[instance.timeReminderBefore]!,
      'instructions': instance.instructions,
    };

const _$ScheduleTypeEnumMap = {
  ScheduleType.asNeeded: 'asNeeded',
  ScheduleType.daily: 'daily',
  ScheduleType.weekly: 'weekly',
  ScheduleType.monthly: 'monthly',
};

const _$TimeReminderBeforeEnumMap = {
  TimeReminderBefore.oneMinute: 'oneMinute',
  TimeReminderBefore.twoMinute: 'twoMinute',
  TimeReminderBefore.fiveMinutes: 'fiveMinutes',
  TimeReminderBefore.tenMinutes: 'tenMinutes',
  TimeReminderBefore.thirthyMinutes: 'thirthyMinutes',
  TimeReminderBefore.oneHour: 'oneHour',
  TimeReminderBefore.twoHours: 'twoHours',
  TimeReminderBefore.threeHours: 'threeHours',
};

const _$TimeReminderLaterEnumMap = {
  TimeReminderLater.oneMinute: 'oneMinute',
  TimeReminderLater.twoMinute: 'twoMinute',
  TimeReminderLater.fiveMinutes: 'fiveMinutes',
  TimeReminderLater.tenMinutes: 'tenMinutes',
  TimeReminderLater.thirthyMinutes: 'thirthyMinutes',
  TimeReminderLater.oneHour: 'oneHour',
  TimeReminderLater.twoHours: 'twoHours',
  TimeReminderLater.threeHours: 'threeHours',
};

const _$IntervalBetweenDosesEnumMap = {
  IntervalBetweenDoses.oneHour: 'oneHour',
  IntervalBetweenDoses.twoHours: 'twoHours',
  IntervalBetweenDoses.threeHours: 'threeHours',
  IntervalBetweenDoses.fourHours: 'fourHours',
  IntervalBetweenDoses.fiveHours: 'fiveHours',
  IntervalBetweenDoses.sixHours: 'sixHours',
  IntervalBetweenDoses.sevenHours: 'sevenHours',
  IntervalBetweenDoses.eightHours: 'eightHours',
  IntervalBetweenDoses.nineHours: 'nineHours',
  IntervalBetweenDoses.tenHours: 'tenHours',
  IntervalBetweenDoses.elevenHours: 'elevenHours',
  IntervalBetweenDoses.twelveHours: 'twelveHours',
  IntervalBetweenDoses.thirteenHours: 'thirteenHours',
  IntervalBetweenDoses.fourteenHours: 'fourteenHours',
  IntervalBetweenDoses.fifteenHours: 'fifteenHours',
  IntervalBetweenDoses.sixteenHours: 'sixteenHours',
  IntervalBetweenDoses.seventeenHours: 'seventeenHours',
  IntervalBetweenDoses.eighteenHours: 'eighteenHours',
  IntervalBetweenDoses.nineteenHours: 'nineteenHours',
  IntervalBetweenDoses.twentyHours: 'twentyHours',
  IntervalBetweenDoses.twentyOneHours: 'twentyOneHours',
  IntervalBetweenDoses.twentyTwoHours: 'twentyTwoHours',
  IntervalBetweenDoses.twentyThreeHours: 'twentyThreeHours',
  IntervalBetweenDoses.twentyFourHours: 'twentyFourHours',
};
