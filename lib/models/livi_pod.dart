import 'package:json_annotation/json_annotation.dart';

import '../controllers/controllers.dart';

part 'livi_pod.g.dart';

@JsonSerializable(explicitToJson: true)
class LiviPod {
  @JsonKey(includeToJson: false)
  String id = '';
  String userId = '';
  final String remoteId;
  @JsonKey(defaultValue: '')
  String macAddress = '';
  @JsonKey(defaultValue: '')
  String ipAddress = '';
  String medicationId = '';

  @JsonKey(includeFromJson: false, includeToJson: false)
  BleDeviceController? bleDeviceController;

  @JsonKey(includeFromJson: false, includeToJson: false)
  DispenseRequest? dispenseRequest;

  LiviPod({required this.remoteId});

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

  void connect() {
    bleDeviceController?.connect();
  }

  void disconnect() {
    bleDeviceController?.disconnect();
  }

  Future<void> reset() async {
    await bleDeviceController?.reset();
  }

  Future<void> dispense(DispenseRequest dr) async {
    dispenseRequest = dr;
    await bleDeviceController?.dispense(dr);
  }

  Future<void> sendDispenseConfirmation() async {
    await bleDeviceController?.sendDispenseConfirmation();
  }
}
