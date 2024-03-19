import 'package:json_annotation/json_annotation.dart';
import 'package:livipod_app/models/app_user.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
class Account {
  String id = '';
  AppUser? owner;

  Account();

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
