import 'package:json_annotation/json_annotation.dart';

import 'app_user_type.dart';
import 'livi_pod.dart';
import 'notification.dart';
import 'notification_type.dart';

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
  int lowInventoryQuantity;
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
  bool allowRemoteDispensing;
  List<String> caregiverIds = [];
  bool useMilitaryTime;
  @JsonKey(defaultValue: <Notification>[])
  List<Notification> notifications = [];

  bool get medicationTaken => notifications
      .singleWhere(
        (element) =>
            element.notificationType == NotificationType.medicationTaken,
        orElse: () => Notification(),
      )
      .enabled;
  bool get medicationAvailable => notifications
      .singleWhere(
        (element) =>
            element.notificationType == NotificationType.medicationAvailable,
        orElse: () => Notification(),
      )
      .enabled;
  bool get medicationLate => notifications
      .singleWhere(
        (element) =>
            element.notificationType == NotificationType.medicationLate,
        orElse: () => Notification(),
      )
      .enabled;
  bool get medicationDue => notifications
      .singleWhere(
          (element) =>
              element.notificationType == NotificationType.medicationDue,
          orElse: () => Notification())
      .enabled;
  bool get medicationMissed => notifications
      .singleWhere(
          (element) =>
              element.notificationType == NotificationType.medicationMissed,
          orElse: () => Notification())
      .enabled;
  bool get inventoryLow => notifications
      .singleWhere(
          (element) =>
              element.notificationType == NotificationType.inventoryLow,
          orElse: () => Notification())
      .enabled;
  bool get inventoryEmpty => notifications
      .singleWhere(
          (element) =>
              element.notificationType == NotificationType.inventoryEmpty,
          orElse: () => Notification())
      .enabled;
  bool get wifiUnavailable => notifications
      .singleWhere(
          (element) =>
              element.notificationType == NotificationType.wifiUnavailable,
          orElse: () => Notification())
      .enabled;

  void setNotification(NotificationType notificationType, bool value) {
    final index = notifications
        .indexWhere((element) => element.notificationType == notificationType);
    if (index != -1) {
      notifications[index].enabled = value;
    } else {
      notifications.add(Notification(notificationType: notificationType));
    }
  }

  AppUser({
    required this.name,
    required this.phoneNumber,
    this.appUserType = AppUserType.selfGuidedUser,
    this.id = '',
    this.accountId = '',
    this.lowInventoryQuantity = 10,
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
    this.allowRemoteDispensing = false,
    this.caregiverIds = const [],
    this.useMilitaryTime = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
