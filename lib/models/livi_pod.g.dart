// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livi_pod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiviPod _$LiviPodFromJson(Map<String, dynamic> json) => LiviPod(
      macAddress: json['macAddress'] as String,
      ipAddress: json['ipAddress'] as String,
      online: json['online'] as bool,
      remoteId: json['remoteId'] as String,
    )..id = json['id'] as String;

Map<String, dynamic> _$LiviPodToJson(LiviPod instance) => <String, dynamic>{
      'id': instance.id,
      'macAddress': instance.macAddress,
      'remoteId': instance.remoteId,
      'ipAddress': instance.ipAddress,
      'online': instance.online,
    };
