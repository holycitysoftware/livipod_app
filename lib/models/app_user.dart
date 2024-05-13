import 'package:json_annotation/json_annotation.dart';
import 'app_user_type.dart';

import 'livi_pod.dart';

part 'app_user.g.dart';

@JsonSerializable(explicitToJson: true)
class AppUser {
  @JsonKey(includeFromJson: false, includeToJson: false)
  String id = '';
  String accountId = '';
  String name = '';
  AppUserType appUserType;
  String phoneNumber = '';
  List<LiviPod> podsList;
  String? email;
  String authToken = '';
  bool enabled;
  String fcmToken = ''; // firebase cloud messaging token
  String timezone;
  bool useEmail;
  bool useSMS;
  bool usePushNotifications;

  AppUser({
    this.id = '',
    this.accountId = '',
    required this.name,
    this.appUserType = AppUserType.selfGuidedUser,
    required this.phoneNumber,
    this.podsList = const [],
    this.email,
    this.authToken = '',
    this.enabled = true,
    this.fcmToken = '',
    this.timezone = 'US/Eastern',
    this.useEmail = false,
    this.useSMS = false,
    this.usePushNotifications = true,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
