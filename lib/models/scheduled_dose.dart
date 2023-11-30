import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scheduled_dose.g.dart';

@JsonSerializable()
class ScheduledDose {
  double qty = 0;
  @DayOfTimeConverter()
  TimeOfDay timeOfDay = const TimeOfDay(hour: 8, minute: 0);

  ScheduledDose();

  factory ScheduledDose.fromJson(Map<String, dynamic> json) =>
      _$ScheduledDoseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduledDoseToJson(this);
}

class DayOfTimeConverter implements JsonConverter<TimeOfDay, String?> {
  const DayOfTimeConverter();

  @override
  TimeOfDay fromJson(String? json) {
    return TimeOfDay.fromDateTime(DateFormat.jm().parse(json ?? ''));
  }

  @override
  String? toJson(TimeOfDay object) {
    return '${object.hour}:${object.minute}';
  }
}
