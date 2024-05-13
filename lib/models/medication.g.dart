// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medication _$MedicationFromJson(Map<String, dynamic> json) => Medication(
      name: json['name'] as String,
    )
      ..appUserId = json['appUserId'] as String
      ..manufacturer = json['manufacturer'] as String
      ..dosageForm = $enumDecode(_$DosageFormEnumMap, json['dosageForm'])
      ..packageId = json['packageId'] as String
      ..strength = json['strength'] as String
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
          : Dosing.fromJson(json['lastDosing'] as Map<String, dynamic>)
      ..inventoryQuantity = json['inventoryQuantity'] as int
      ..type = $enumDecode(_$ScheduleTypeEnumMap, json['type'])
      ..enabled = json['enabled'] as bool;

Map<String, dynamic> _$MedicationToJson(Medication instance) =>
    <String, dynamic>{
      'appUserId': instance.appUserId,
      'name': instance.name,
      'manufacturer': instance.manufacturer,
      'dosageForm': _$DosageFormEnumMap[instance.dosageForm]!,
      'packageId': instance.packageId,
      'strength': instance.strength,
      'instructions': instance.instructions,
      'schedules': instance.schedules.map((e) => e.toJson()).toList(),
      'hasChanged': instance.hasChanged,
      'nextDosing': instance.nextDosing?.toJson(),
      'lastDosing': instance.lastDosing?.toJson(),
      'inventoryQuantity': instance.inventoryQuantity,
      'type': _$ScheduleTypeEnumMap[instance.type]!,
      'enabled': instance.enabled,
    };

const _$DosageFormEnumMap = {
  DosageForm.none: 'none',
  DosageForm.capsule: 'capsule',
  DosageForm.tablet: 'tablet',
  DosageForm.drops: 'drops',
  DosageForm.injection: 'injection',
  DosageForm.ointment: 'ointment',
  DosageForm.liquid: 'liquid',
  DosageForm.patch: 'patch',
  DosageForm.other: 'other',
};

const _$ScheduleTypeEnumMap = {
  ScheduleType.asNeeded: 'asNeeded',
  ScheduleType.daily: 'daily',
  ScheduleType.weekly: 'weekly',
  ScheduleType.monthly: 'monthly',
};
