import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable(explicitToJson: true)
class Account {
  @JsonKey(defaultValue: '')
  String id = '';
  String ownerId = '';
  bool enabled = true;

  Account({this.id = '', this.ownerId = '', this.enabled = true});

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
