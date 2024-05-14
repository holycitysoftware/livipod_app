// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      ownerId: json['ownerId'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'ownerId': instance.ownerId,
      'enabled': instance.enabled,
    };
