// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_dose.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledDose _$ScheduledDoseFromJson(Map<String, dynamic> json) =>
    ScheduledDose()
      ..qty = (json['qty'] as num).toDouble()
      ..hour = json['hour'] as int
      ..minute = json['minute'] as int;

Map<String, dynamic> _$ScheduledDoseToJson(ScheduledDose instance) =>
    <String, dynamic>{
      'qty': instance.qty,
      'hour': instance.hour,
      'minute': instance.minute,
    };
