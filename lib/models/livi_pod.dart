import 'package:json_annotation/json_annotation.dart';

import 'schedule.dart';

part 'livi_pod.g.dart';

@JsonSerializable(explicitToJson: true)
class LiviPod {
  String id = '';
  final String remoteId;
  String medicationName;
  @JsonKey(defaultValue: <Schedule>[])
  List<Schedule> schedules = [];

  LiviPod({required this.remoteId, required this.medicationName});

  factory LiviPod.fromJson(Map<String, dynamic> json) =>
      _$LiviPodFromJson(json);

  Map<String, dynamic> toJson() => _$LiviPodToJson(this);
}
