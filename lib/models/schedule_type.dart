import 'package:json_annotation/json_annotation.dart';

import '../utils/strings.dart';

enum ScheduleType {
  @JsonValue('asNeeded')
  asNeeded(description: Strings.asNeeded),
  @JsonValue('daily')
  daily(description: Strings.daily),
  @JsonValue('weekly')
  weekly(description: Strings.weekly),
  @JsonValue('monthly')
  monthly(description: Strings.monthly);

  const ScheduleType({
    required this.description,
  });

  final String description;

  bool isAsNeeded() => this == ScheduleType.asNeeded;
  bool isDaily() => this == ScheduleType.daily;
  bool isWeekly() => this == ScheduleType.weekly;
  bool isMonthly() => this == ScheduleType.monthly;

  @override
  String toString() => description;

  @override
  int compareTo(ScheduleType other) => description.compareTo(other.description);
}

extension ParseToString on ScheduleType {
  String toUppercaseString() {
    return toString().split('.').last.toUpperCase();
  }
}
