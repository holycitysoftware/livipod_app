import 'package:json_annotation/json_annotation.dart';

part 'command_response.g.dart';

enum ResponseEvent { commandReceived, dispensing }

enum DispenseStatus { idle, counting, complete, noneDetect, sensorBlock }

@JsonSerializable()
class CommandResponse {
  final ResponseEvent event;
  final String macAddress;
  @JsonKey(defaultValue: 1)
  int result = 1;
  @JsonKey(defaultValue: 0)
  int requested = 0;
  @JsonKey(defaultValue: 0)
  int dispensed = 0;
  @JsonKey(defaultValue: DispenseStatus.idle)
  DispenseStatus status = DispenseStatus.idle;

  CommandResponse({required this.event, required this.macAddress});

  factory CommandResponse.fromJson(Map<String, dynamic> json) =>
      _$CommandResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommandResponseToJson(this);
}
