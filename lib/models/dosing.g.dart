// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dosing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dosing _$DosingFromJson(Map<String, dynamic> json) => Dosing()
  ..dosingId = json['dosingId'] as int
  ..scheduledDosingTime = json['scheduledDosingTime'] == null
      ? null
      : DateTime.parse(json['scheduledDosingTime'] as String)
  ..lastDosingTime = json['lastDosingTime'] == null
      ? null
      : DateTime.parse(json['lastDosingTime'] as String)
  ..qtyRequested = (json['qtyRequested'] as num).toDouble()
  ..qtyRemaining = (json['qtyRemaining'] as num).toDouble()
  ..qtyRemainingForDay = (json['qtyRemainingForDay'] as num?)?.toDouble() ?? 0
  ..qtySkipped = (json['qtySkipped'] as num?)?.toDouble() ?? 0
  ..qtyMissed = (json['qtyMissed'] as num?)?.toDouble() ?? 0
  ..qtyDispensed = (json['qtyDispensed'] as num?)?.toDouble() ?? 0
  ..outcome = $enumDecodeNullable(_$DosingOutcomeEnumMap, json['outcome']);

Map<String, dynamic> _$DosingToJson(Dosing instance) => <String, dynamic>{
      'dosingId': instance.dosingId,
      'scheduledDosingTime': instance.scheduledDosingTime?.toIso8601String(),
      'lastDosingTime': instance.lastDosingTime?.toIso8601String(),
      'qtyRequested': instance.qtyRequested,
      'qtyRemaining': instance.qtyRemaining,
      'qtyRemainingForDay': instance.qtyRemainingForDay,
      'qtySkipped': instance.qtySkipped,
      'qtyMissed': instance.qtyMissed,
      'qtyDispensed': instance.qtyDispensed,
      'outcome': _$DosingOutcomeEnumMap[instance.outcome],
    };

const _$DosingOutcomeEnumMap = {
  DosingOutcome.missed: 'missed',
  DosingOutcome.skipped: 'skipped',
  DosingOutcome.taken: 'taken',
  DosingOutcome.jam: 'jam',
};
