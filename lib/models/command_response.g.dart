// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'command_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommandResponse _$CommandResponseFromJson(Map<String, dynamic> json) =>
    CommandResponse(
      event: $enumDecode(_$ResponseEventEnumMap, json['event']),
      macAddress: json['macAddress'] as String,
    )
      ..result = json['result'] as int? ?? 1
      ..requested = json['requested'] as int? ?? 0
      ..dispensed = json['dispensed'] as int? ?? 0
      ..status = $enumDecodeNullable(_$DispenseStatusEnumMap, json['status']) ??
          DispenseStatus.idle;

Map<String, dynamic> _$CommandResponseToJson(CommandResponse instance) =>
    <String, dynamic>{
      'event': _$ResponseEventEnumMap[instance.event]!,
      'macAddress': instance.macAddress,
      'result': instance.result,
      'requested': instance.requested,
      'dispensed': instance.dispensed,
      'status': _$DispenseStatusEnumMap[instance.status]!,
    };

const _$ResponseEventEnumMap = {
  ResponseEvent.commandReceived: 'commandReceived',
  ResponseEvent.dispensing: 'dispensing',
};

const _$DispenseStatusEnumMap = {
  DispenseStatus.idle: 'idle',
  DispenseStatus.counting: 'counting',
  DispenseStatus.complete: 'complete',
  DispenseStatus.noneDetect: 'noneDetect',
  DispenseStatus.sensorBlock: 'sensorBlock',
};
