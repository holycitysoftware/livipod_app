// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicationHistory _$MedicationHistoryFromJson(Map<String, dynamic> json) =>
    MedicationHistory(
      dateTime: DateTime.parse(json['dateTime'] as String),
    )
      ..accountId = json['accountId'] as String
      ..firstName = json['firstName'] as String
      ..lastName = json['lastName'] as String
      ..medicationId = json['medicationId'] as String
      ..medicationName = json['medicationName'] as String
      ..outcome = $enumDecode(_$DosingOutcomeEnumMap, json['outcome'])
      ..qtyDispensed = (json['qtyDispensed'] as num).toDouble()
      ..qtyMissed = (json['qtyMissed'] as num).toDouble()
      ..qtyRemaining = (json['qtyRemaining'] as num).toDouble()
      ..qtyRequested = (json['qtyRequested'] as num).toDouble()
      ..qtySkipped = (json['qtySkipped'] as num).toDouble()
      ..scheduledDosingTime = json['scheduledDosingTime'] == null
          ? null
          : DateTime.parse(json['scheduledDosingTime'] as String)
      ..appUserId = json['appUserId'] as String;

Map<String, dynamic> _$MedicationHistoryToJson(MedicationHistory instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'dateTime': instance.dateTime.toIso8601String(),
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'medicationId': instance.medicationId,
      'medicationName': instance.medicationName,
      'outcome': _$DosingOutcomeEnumMap[instance.outcome]!,
      'qtyDispensed': instance.qtyDispensed,
      'qtyMissed': instance.qtyMissed,
      'qtyRemaining': instance.qtyRemaining,
      'qtyRequested': instance.qtyRequested,
      'qtySkipped': instance.qtySkipped,
      'scheduledDosingTime': instance.scheduledDosingTime?.toIso8601String(),
      'appUserId': instance.appUserId,
    };

const _$DosingOutcomeEnumMap = {
  DosingOutcome.missed: 'missed',
  DosingOutcome.skipped: 'skipped',
  DosingOutcome.taken: 'taken',
  DosingOutcome.jam: 'jam',
};
