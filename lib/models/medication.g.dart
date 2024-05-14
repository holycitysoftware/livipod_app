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
      ..inventoryQuantity = json['inventoryQuantity'] as int
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
          : Dosing.fromJson(json['lastDosing'] as Map<String, dynamic>);

Map<String, dynamic> _$MedicationToJson(Medication instance) =>
    <String, dynamic>{
      'appUserId': instance.appUserId,
      'name': instance.name,
      'manufacturer': instance.manufacturer,
      'dosageForm': _$DosageFormEnumMap[instance.dosageForm]!,
      'inventoryQuantity': instance.inventoryQuantity,
      'packageId': instance.packageId,
      'strength': instance.strength,
      'instructions': instance.instructions,
      'schedules': instance.schedules.map((e) => e.toJson()).toList(),
      'hasChanged': instance.hasChanged,
      'nextDosing': instance.nextDosing?.toJson(),
      'lastDosing': instance.lastDosing?.toJson(),
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
