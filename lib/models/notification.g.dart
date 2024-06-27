// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      notificationType: $enumDecodeNullable(
              _$NotificationTypeEnumMap, json['notificationType']) ??
          NotificationType.none,
      enabled: json['enabled'] as bool? ?? false,
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'notificationType': _$NotificationTypeEnumMap[instance.notificationType]!,
      'enabled': instance.enabled,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.medicationTaken: 'medicationTaken',
  NotificationType.medicationAvailable: 'medicationAvailable',
  NotificationType.medicationDue: 'medicationDue',
  NotificationType.medicationLate: 'medicationLate',
  NotificationType.medicationMissed: 'medicationMissed',
  NotificationType.inventoryLow: 'inventoryLow',
  NotificationType.inventoryEmpty: 'inventoryEmpty',
  NotificationType.wifiUnavailable: 'wifiUnavailable',
  NotificationType.none: 'none',
};
