import 'package:json_annotation/json_annotation.dart';

part 'dosing.g.dart';

@JsonSerializable(explicitToJson: true)
class Dosing {
  int dosingId = 0;
  DateTime? scheduledDosingTime;
  DateTime? lastDosingTime;
  double qtyRequested = 0;
  double qtyRemaining = 0;
  @JsonKey(defaultValue: 0)
  double qtySkipped = 0;
  @JsonKey(defaultValue: 0)
  double qtyMissed = 0;
  @JsonKey(defaultValue: 0)
  double qtyDispensed = 0;
  @JsonKey(defaultValue: '')
  String outcome = '';

  Dosing();

  factory Dosing.fromJson(Map<String, dynamic> json) => _$DosingFromJson(json);

  Map<String, dynamic> toJson() => _$DosingToJson(this);
}
