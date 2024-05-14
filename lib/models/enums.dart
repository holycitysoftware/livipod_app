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

enum TimeReminderBefore implements Comparable<TimeReminderBefore> {
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
  ),
  twoHours(
    description: Strings.twoHoursBefore,
    duration: Duration(hours: 2),
  ),
  threeHours(
    description: Strings.threeHoursBefore,
    duration: Duration(hours: 3),
  );

  const TimeReminderBefore({
    required this.description,
    required this.duration,
  });

  final String description;
  final Duration duration;

  @override
  String toString() => description;

  @override
  int compareTo(TimeReminderBefore other) => duration.compareTo(other.duration);
}

enum TimeReminderLater implements Comparable<TimeReminderLater> {
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
  ),
  twoHours(
    description: Strings.twoHoursLater,
    duration: Duration(hours: 2),
  ),
  threeHours(
    description: Strings.threeHoursLater,
    duration: Duration(hours: 3),
  );

  const TimeReminderLater({
    required this.description,
    required this.duration,
  });

  final String description;
  final Duration duration;

  @override
  String toString() => description;

  @override
  int compareTo(TimeReminderLater other) => duration.compareTo(other.duration);
}

enum IntervalBetweenDoses implements Comparable<IntervalBetweenDoses> {
  oneHour(
    description: Strings.oneHour,
    duration: Duration(hours: 1),
  ),
  twoHours(
    description: Strings.twoHours,
    duration: Duration(hours: 2),
  ),
  threeHours(
    description: Strings.threeHours,
    duration: Duration(hours: 3),
  ),
  fourHours(
    description: Strings.fourHours,
    duration: Duration(hours: 4),
  ),
  fiveHours(
    description: Strings.fiveHours,
    duration: Duration(hours: 5),
  ),
  sixHours(
    description: Strings.sixHours,
    duration: Duration(hours: 6),
  ),
  sevenHours(
    description: Strings.sevenHours,
    duration: Duration(hours: 7),
  ),
  eightHours(
    description: Strings.eightHours,
    duration: Duration(hours: 8),
  ),
  nineHours(
    description: Strings.nineHours,
    duration: Duration(hours: 9),
  ),
  tenHours(
    description: Strings.tenHours,
    duration: Duration(hours: 10),
  ),
  elevenHours(
    description: Strings.elevenHours,
    duration: Duration(hours: 11),
  ),
  twelveHours(
    description: Strings.twelveHours,
    duration: Duration(hours: 12),
  ),
  thirteenHours(
    description: Strings.thirteenHours,
    duration: Duration(hours: 13),
  ),
  fourteenHours(
    description: Strings.fourteenHours,
    duration: Duration(hours: 14),
  ),
  fifteenHours(
    description: Strings.fifteenHours,
    duration: Duration(hours: 15),
  ),
  sixteenHours(
    description: Strings.sixteenHours,
    duration: Duration(hours: 16),
  ),
  seventeenHours(
    description: Strings.seventeenHours,
    duration: Duration(hours: 17),
  ),
  eighteenHours(
    description: Strings.eighteenHours,
    duration: Duration(hours: 18),
  ),
  nineteenHours(
    description: Strings.nineteenHours,
    duration: Duration(hours: 19),
  ),
  twentyHours(
    description: Strings.twentyHours,
    duration: Duration(hours: 20),
  ),
  twentyOneHours(
    description: Strings.twentyOneHours,
    duration: Duration(hours: 21),
  ),
  twentyTwoHours(
    description: Strings.twentyTwoHours,
    duration: Duration(hours: 22),
  ),
  twentyThreeHours(
    description: Strings.twentyThreeHours,
    duration: Duration(hours: 23),
  ),
  twentyFourHours(
    description: Strings.twentyFourHours,
    duration: Duration(hours: 24),
  );

  const IntervalBetweenDoses({
    required this.description,
    required this.duration,
  });

  final String description;
  final Duration duration;

  @override
  String toString() => description;

  @override
  int compareTo(IntervalBetweenDoses other) =>
      duration.compareTo(other.duration);
}

enum Days implements Comparable<Days> {
  sunday(description: Strings.sunday),
  monday(description: Strings.monday),
  tuesday(description: Strings.tuesday),
  wednesday(description: Strings.wednesday),
  thursday(description: Strings.thursday),
  friday(description: Strings.friday),
  saturday(description: Strings.saturday);

  const Days({
    required this.description,
  });

  final String description;

  @override
  String toString() => description;

  @override
  int compareTo(Days other) => description.compareTo(other.description);
}