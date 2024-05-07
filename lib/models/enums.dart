import '../utils/strings.dart';

enum DosageForm implements Comparable<DosageForm> {
  none(description: Strings.none),
  capsule(description: Strings.capsule),
  tablet(description: Strings.tablet),
  drops(description: Strings.drops),
  injection(description: Strings.injection),
  ointment(description: Strings.ointment),
  liquid(description: Strings.liquid),
  patch(description: Strings.patch),
  other(description: Strings.other);

  const DosageForm({
    required this.description,
  });

  final String description;

  @override
  String toString() => description;

  @override
  int compareTo(DosageForm other) => description.compareTo(other.description);
}

enum Frequency implements Comparable<Frequency> {
  asNeeded(description: Strings.asNeeded),
  daily(description: Strings.daily),
  weekly(description: Strings.weekly),
  monthly(description: Strings.monthly);

  const Frequency({
    required this.description,
  });

  final String description;

  bool isAsNeeded() => this == Frequency.asNeeded;
  bool isDaily() => this == Frequency.daily;
  bool isWeekly() => this == Frequency.weekly;
  bool isMonthly() => this == Frequency.monthly;

  @override
  String toString() => description;

  @override
  int compareTo(Frequency other) => description.compareTo(other.description);
}

enum DayTime implements Comparable<DayTime> {
  am(description: Strings.AM),
  pm(description: Strings.PM);

  const DayTime({
    required this.description,
  });

  final String description;

  @override
  String toString() => description;

  @override
  int compareTo(DayTime other) => description.compareTo(other.description);
}

enum DayOfWeek implements Comparable<DayOfWeek> {
  sunday(description: Strings.sunday),
  monday(description: Strings.monday),
  tuesday(description: Strings.tuesday),
  wednesday(description: Strings.wednesday),
  thursday(description: Strings.thursday),
  friday(description: Strings.friday),
  saturday(description: Strings.saturday);

  const DayOfWeek({
    required this.description,
  });

  final String description;

  bool get isWeekend => this == DayOfWeek.saturday || this == DayOfWeek.sunday;

  @override
  String toString() => description;

  @override
  int compareTo(DayOfWeek other) => description.compareTo(other.description);
}

enum TimeReminderBefore implements Comparable<DayOfWeek> {
  oneMinute(
    description: Strings.oneMinuteBefore,
    duration: Duration(minutes: 1),
  ),
  twoMinute(
    description: Strings.twoMinutesBefore,
    duration: Duration(minutes: 2),
  ),
  fiveMinutes(
    description: Strings.fiveMinutesBefore,
    duration: Duration(minutes: 5),
  ),
  tenMinutes(
    description: Strings.tenMinutesBefore,
    duration: Duration(minutes: 10),
  ),
  thirthyMinutes(
    description: Strings.thirthyMinutesBefore,
    duration: Duration(minutes: 30),
  ),
  oneHour(
    description: Strings.oneHourBefore,
    duration: Duration(hours: 1),
  );

  const TimeReminderBefore({
    required this.description,
    required this.duration,
  });

  final String description;
  final Duration duration;

  bool get isWeekend => this == DayOfWeek.saturday || this == DayOfWeek.sunday;

  @override
  String toString() => description;

  @override
  int compareTo(DayOfWeek other) => description.compareTo(other.description);
}

enum TimeReminderLater implements Comparable<DayOfWeek> {
  oneMinute(
    description: Strings.oneMinuteLater,
    duration: Duration(minutes: 1),
  ),
  twoMinute(
    description: Strings.twoMinutesLater,
    duration: Duration(minutes: 2),
  ),
  fiveMinutes(
    description: Strings.fiveMinutesLater,
    duration: Duration(minutes: 5),
  ),
  tenMinutes(
    description: Strings.tenMinutesLater,
    duration: Duration(minutes: 10),
  ),
  thirthyMinutes(
    description: Strings.thirthyMinutesLater,
    duration: Duration(minutes: 30),
  ),
  oneHour(
    description: Strings.oneHourLater,
    duration: Duration(hours: 1),
  );

  const TimeReminderLater({
    required this.description,
    required this.duration,
  });

  final String description;
  final Duration duration;

  bool get isWeekend => this == DayOfWeek.saturday || this == DayOfWeek.sunday;

  @override
  String toString() => description;

  @override
  int compareTo(DayOfWeek other) => description.compareTo(other.description);
}
