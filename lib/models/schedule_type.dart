import 'package:json_annotation/json_annotation.dart';

enum ScheduleType {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('asNeeded')
  asNeeded
}

extension ParseToString on ScheduleType {
  String toUppercaseString() {
    return toString().split('.').last.toUpperCase();
  }
}
