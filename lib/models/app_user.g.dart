// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      appUserType:
          $enumDecodeNullable(_$AppUserTypeEnumMap, json['appUserType']) ??
              AppUserType.selfGuidedUser,
      accountId: json['accountId'] as String? ?? '',
      language: json['language'] as String? ?? 'en',
      podsList: (json['podsList'] as List<dynamic>?)
              ?.map((e) => LiviPod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      email: json['email'] as String?,
      authToken: json['authToken'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
      fcmToken: json['fcmToken'] as String? ?? '',
      timezone: json['timezone'] as String? ?? 'US/Eastern',
      useEmail: json['useEmail'] as bool? ?? false,
      useSMS: json['useSMS'] as bool? ?? false,
      usePushNotifications: json['usePushNotifications'] as bool? ?? true,
      base64EncodedImage: json['base64EncodedImage'] as String? ?? '',
      allowAutomaticDispensing:
          json['allowAutomaticDispensing'] as bool? ?? false,
      caregiverIds: (json['caregiverIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      useMilitaryTime: json['useMilitaryTime'] as bool? ?? false,
    )
      ..authId = json['authId'] as String
      ..notifications = (json['notifications'] as List<dynamic>?)
              ?.map((e) => Notification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'authId': instance.authId,
      'accountId': instance.accountId,
      'name': instance.name,
      'appUserType': _$AppUserTypeEnumMap[instance.appUserType]!,
      'phoneNumber': instance.phoneNumber,
      'podsList': instance.podsList.map((e) => e.toJson()).toList(),
      'email': instance.email,
      'authToken': instance.authToken,
      'enabled': instance.enabled,
      'language': instance.language,
      'fcmToken': instance.fcmToken,
      'timezone': instance.timezone,
      'useEmail': instance.useEmail,
      'useSMS': instance.useSMS,
      'usePushNotifications': instance.usePushNotifications,
      'base64EncodedImage': instance.base64EncodedImage,
      'allowAutomaticDispensing': instance.allowAutomaticDispensing,
      'caregiverIds': instance.caregiverIds,
      'useMilitaryTime': instance.useMilitaryTime,
      'notifications': instance.notifications.map((e) => e.toJson()).toList(),
    };

const _$AppUserTypeEnumMap = {
  AppUserType.selfGuidedUser: 'selfGuidedUser',
  AppUserType.assistedUser: 'assistedUser',
  AppUserType.caredForUser: 'caredForUser',
  AppUserType.caregiver: 'caregiver',
};
