// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser()
  ..id = json['id'] as String
  ..account = json['account'] == null
      ? null
      : Account.fromJson(json['account'] as Map<String, dynamic>)
  ..firstName = json['firstName'] as String
  ..lastName = json['lastName'] as String
  ..appUserType = $enumDecode(_$AppUserTypeEnumMap, json['appUserType'])
  ..mobile = json['mobile'] as String
  ..podsList = (json['podsList'] as List<dynamic>)
      .map((e) => LiviPod.fromJson(e as Map<String, dynamic>))
      .toList()
  ..email = json['email'] as String
  ..authToken = json['authToken'] as String;

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'account': instance.account?.toJson(),
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'appUserType': _$AppUserTypeEnumMap[instance.appUserType]!,
      'mobile': instance.mobile,
      'podsList': instance.podsList.map((e) => e.toJson()).toList(),
      'email': instance.email,
      'authToken': instance.authToken,
    };

const _$AppUserTypeEnumMap = {
  AppUserType.selfGuidedUser: 'selfGuidedUser',
  AppUserType.assistedUser: 'assistedUser',
  AppUserType.caredForUser: 'caredForUser',
  AppUserType.caregiver: 'caregiver',
};
