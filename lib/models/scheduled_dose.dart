import 'package:json_annotation/json_annotation.dart';

part 'scheduled_dose.g.dart';

@JsonSerializable()
class ScheduledDose {
  double qty = 0;
  int hour = 0;
  int minute = 0;

  ScheduledDose();

  factory ScheduledDose.fromJson(Map<String, dynamic> json) =>
      _$ScheduledDoseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduledDoseToJson(this);
}
