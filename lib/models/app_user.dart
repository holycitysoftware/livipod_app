import 'package:json_annotation/json_annotation.dart';
import 'app_user_type.dart';

import 'livi_pod.dart';
import 'notification.dart';

part 'app_user.g.dart';

@JsonSerializable(explicitToJson: true)
class AppUser {
  @JsonKey(includeFromJson: false, includeToJson: false)
  String id = '';
  String authId = '';
  String accountId = '';
  String name = '';
  AppUserType appUserType;
  String phoneNumber = '';
  List<LiviPod> podsList;
  String? email;
  String authToken = '';
  bool enabled;
  String language;
  String fcmToken = ''; // firebase cloud messaging token
  String timezone;
  bool useEmail;
  bool useSMS;
  bool usePushNotifications;
  String base64EncodedImage;
  bool allowAutomaticDispensing;
  List<String> caregiverIds = [];
  bool useMilitaryTime;
  @JsonKey(defaultValue: <Notification>[])
  List<Notification> notifications = [];

  AppUser(
      {required this.name,
      required this.phoneNumber,
      this.appUserType = AppUserType.selfGuidedUser,
      this.id = '',
      this.accountId = '',
      this.language = 'en',
      this.podsList = const [],
      this.email,
      this.authToken = '',
      this.enabled = true,
      this.fcmToken = '',
      this.timezone = 'US/Eastern',
      this.useEmail = false,
      this.useSMS = false,
      this.usePushNotifications = true,
      this.base64EncodedImage = '',
      this.allowAutomaticDispensing = false,
      this.caregiverIds = const [],
      this.useMilitaryTime = false});

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
