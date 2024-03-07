import 'package:json_annotation/json_annotation.dart';

import 'dosing.dart';
import 'schedule.dart';

part 'livi_pod.g.dart';

@JsonSerializable(explicitToJson: true)
class LiviPod {
  String id = '';
  final String remoteId;
  String medicationName;
  Schedule? schedule;
  Dosing? nextDosing;
  Dosing? lastDosing;

  LiviPod({required this.remoteId, required this.medicationName});

  factory LiviPod.fromJson(Map<String, dynamic> json) =>
      _$LiviPodFromJson(json);

  Map<String, dynamic> toJson() => _$LiviPodToJson(this);
}
