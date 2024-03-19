// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account()
  ..id = json['id'] as String
  ..owner = json['owner'] == null
      ? null
      : AppUser.fromJson(json['owner'] as Map<String, dynamic>);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner?.toJson(),
    };
