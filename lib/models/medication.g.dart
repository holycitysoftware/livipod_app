// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medication _$MedicationFromJson(Map<String, dynamic> json) => Medication()
  ..id = json['id'] as String
  ..appUserId = json['appUserId'] as String
  ..name = json['name'] as String
  ..manufacturer = json['manufacturer'] as String
  ..packageId = json['packageId'] as String
  ..instructions = json['instructions'] as String
  ..schedules = (json['schedules'] as List<dynamic>?)
          ?.map((e) => Schedule.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..hasChanged = json['hasChanged'] as bool
  ..nextDosing = json['nextDosing'] == null
      ? null
      : Dosing.fromJson(json['nextDosing'] as Map<String, dynamic>)
  ..lastDosing = json['lastDosing'] == null
      ? null
      : Dosing.fromJson(json['lastDosing'] as Map<String, dynamic>);

Map<String, dynamic> _$MedicationToJson(Medication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appUserId': instance.appUserId,
      'name': instance.name,
      'manufacturer': instance.manufacturer,
      'packageId': instance.packageId,
      'instructions': instance.instructions,
      'schedules': instance.schedules.map((e) => e.toJson()).toList(),
      'hasChanged': instance.hasChanged,
      'nextDosing': instance.nextDosing?.toJson(),
      'lastDosing': instance.lastDosing?.toJson(),
    };
