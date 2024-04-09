import 'package:json_annotation/json_annotation.dart';
import 'app_user_type.dart';

import 'livi_pod.dart';

part 'app_user.g.dart';

@JsonSerializable(explicitToJson: true)
class AppUser {
  String id = '';
  String accountId = '';
  String firstName = '';
  String lastName = '';
  AppUserType appUserType = AppUserType.selfGuidedUser;
  String phoneNumber = '';
  List<LiviPod> podsList = [];
  String email = '';
  String authToken = '';
  bool enabled = true;
  String fcmToken = ''; // firebase cloud messaging token
  String timezone = 'US/Eastern';
  bool useEmail = false;
  bool useSMS = false;
  bool usePushNotifications = true;

  AppUser();

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
