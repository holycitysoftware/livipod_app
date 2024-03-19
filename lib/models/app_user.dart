import 'package:json_annotation/json_annotation.dart';
import 'package:livipod_app/models/app_user_type.dart';

import 'account.dart';
import 'livi_pod.dart';

part 'app_user.g.dart';

@JsonSerializable(explicitToJson: true)
class AppUser {
  String id = '';
  Account? account;
  String firstName = '';
  String lastName = '';
  AppUserType appUserType = AppUserType.selfGuidedUser;
  String mobile = '';
  List<LiviPod> podsList = [];
  String email = '';
  String authToken = '';

  AppUser();

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
