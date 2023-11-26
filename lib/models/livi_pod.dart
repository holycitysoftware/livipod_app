import 'package:json_annotation/json_annotation.dart';

import 'medication.dart';

part 'livi_pod.g.dart';

@JsonSerializable(explicitToJson: true)
class LiviPod {
  String id = '';
  final String macAddress;
  final String remoteId;
  String ipAddress;
  bool online;
  Medication? medication;

  LiviPod(
      {required this.macAddress,
      required this.ipAddress,
      required this.online,
      required this.remoteId});

  factory LiviPod.fromJson(Map<String, dynamic> json) =>
      _$LiviPodFromJson(json);

  Map<String, dynamic> toJson() => _$LiviPodToJson(this);
}
