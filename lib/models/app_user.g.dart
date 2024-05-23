// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      accountId: json['accountId'] as String? ?? '',
      name: json['name'] as String,
      appUserType:
          $enumDecodeNullable(_$AppUserTypeEnumMap, json['appUserType']) ??
              AppUserType.selfGuidedUser,
      phoneNumber: json['phoneNumber'] as String,
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
    )..authId = json['authId'] as String;

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
    };

const _$AppUserTypeEnumMap = {
  AppUserType.selfGuidedUser: 'selfGuidedUser',
  AppUserType.assistedUser: 'assistedUser',
  AppUserType.caredForUser: 'caredForUser',
  AppUserType.caregiver: 'caregiver',
};
