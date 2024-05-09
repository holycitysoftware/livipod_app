// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_dose.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledDose _$ScheduledDoseFromJson(Map<String, dynamic> json) =>
    ScheduledDose(
      qty: (json['qty'] as num?)?.toDouble() ?? 1,
      timeOfDay:
          const DayOfTimeConverter().fromJson(json['timeOfDay'] as String?),
    );

Map<String, dynamic> _$ScheduledDoseToJson(ScheduledDose instance) =>
    <String, dynamic>{
      'qty': instance.qty,
      'timeOfDay': const DayOfTimeConverter().toJson(instance.timeOfDay),
    };
