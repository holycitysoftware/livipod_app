// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'livi_pod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiviPod _$LiviPodFromJson(Map<String, dynamic> json) => LiviPod(
      remoteId: json['remoteId'] as String,
      medicationName: json['medicationName'] as String,
    )
      ..id = json['id'] as String
      ..schedules = (json['schedules'] as List<dynamic>?)
              ?.map((e) => Schedule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

Map<String, dynamic> _$LiviPodToJson(LiviPod instance) => <String, dynamic>{
      'id': instance.id,
      'remoteId': instance.remoteId,
      'medicationName': instance.medicationName,
      'schedules': instance.schedules.map((e) => e.toJson()).toList(),
    };
