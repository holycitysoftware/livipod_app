// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livi_pod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiviPod _$LiviPodFromJson(Map<String, dynamic> json) => LiviPod(
      remoteId: json['remoteId'] as String,
    )
      ..appUserId = json['appUserId'] as String
      ..macAddress = json['macAddress'] as String? ?? ''
      ..ipAddress = json['ipAddress'] as String? ?? ''
      ..medicationId = json['medicationId'] as String;

Map<String, dynamic> _$LiviPodToJson(LiviPod instance) => <String, dynamic>{
      'appUserId': instance.appUserId,
      'remoteId': instance.remoteId,
      'macAddress': instance.macAddress,
      'ipAddress': instance.ipAddress,
      'medicationId': instance.medicationId,
    };
