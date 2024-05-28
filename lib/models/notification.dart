import 'package:json_annotation/json_annotation.dart';

import 'notification_type.dart';

part 'notification.g.dart';

@JsonSerializable(explicitToJson: true)
class Notification {
  NotificationType notificationType;
  bool enabled = false;

  Notification({this.notificationType = NotificationType.none});

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
