import 'package:json_annotation/json_annotation.dart';

import '../controllers/controllers.dart';
import 'dosing.dart';
import 'schedule.dart';

part 'livi_pod.g.dart';

@JsonSerializable(explicitToJson: true)
class LiviPod {
  String id = '';
  final String remoteId;
  @JsonKey(defaultValue: '')
  String macAddress = '';
  @JsonKey(defaultValue: '')
  String ipAddress = '';
  String medicationName;
  Schedule? schedule;
  Dosing? nextDosing;
  Dosing? lastDosing;
  @JsonKey(includeFromJson: false, includeToJson: false)
  BleDeviceController? bleDeviceController;

  LiviPod({required this.remoteId, required this.medicationName});

  factory LiviPod.fromJson(Map<String, dynamic> json) =>
      _$LiviPodFromJson(json);

  Map<String, dynamic> toJson() => _$LiviPodToJson(this);

  Future<void> startBlink() async {
    await bleDeviceController?.startBlink();
  }

  Future<void> stopBlink() async {
    await bleDeviceController?.stopBlink();
  }

  Future<void> claim() async {
    await bleDeviceController?.claim(id);
  }

  Future<void> unclaim() async {
    await bleDeviceController?.unclaim();
  }
}
