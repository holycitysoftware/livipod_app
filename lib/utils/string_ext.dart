import 'package:intl/intl.dart';

import 'strings.dart';

// ignore: avoid_classes_with_only_static_members
class Formatter {
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    final format = DateFormat('MM/dd/yyyy');
    final outputDate = format.format(dateTime);
    return outputDate;
  }

  static String formatDateString(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    final format = DateFormat('MMM/dd/yyyy');
    final outputDate = format.format(dateTime);
    return outputDate;
  }

  static String formatHour(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    final format = DateFormat('hh:mm a');
    final outputHour = format.format(dateTime);
    return outputHour;
  }
}

extension DateTimeExt on DateTime {
  bool isSameDayMonthYear(DateTime now) {
    return now.year == year && now.month == month && now.day == day;
  }

  DateTime wholeDay() {
    return DateTime(year, month, day, 23, 59, 59);
  }

  bool isTomorrow() {
    final DateTime now = DateTime.now();
    return DateTime(year, month, day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        1;
  }

  bool isToday() {
    final DateTime now = DateTime.now();
    return DateTime(year, month, day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        0;
  }

  bool isBeforeIgnoringTimezone(DateTime date) {
    return DateTime(year, month, day, hour, minute, second).isBefore(
      DateTime(
          date.year, date.month, date.day, date.hour, date.minute, date.second),
    );
  }

  bool isAfterIgnoringTimezone(DateTime date) {
    return DateTime(year, month, day, hour, minute, second).isAfter(
      DateTime(
          date.year, date.month, date.day, date.hour, date.minute, date.second),
    );
  }
}

extension IntExt on int {
  bool isWeekend() {
    return this == 0 || this == 6;
  }
}

extension StringExt on String {
  String extendText() {
    return replaceAll('', '\u{200B}');
  }

  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }

    ///capitalize first letter of all words
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  String requiredSymbol() {
    return '$this*';
  }

  String getFirstLetter() {
    return this[0];
  }

  String getFirstWord() {
    return this.split(' ').first;
  }

  String removeExceptionString() {
    return replaceAll('Exception: ', '');
  }

  bool isTrue() {
    return this == 1.toString();
  }

  bool isFalse() {
    return this == 0.toString();
  }

  String capitalize() {
    if (this == '') {
      return '';
    }
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String addSpaceAfterWord() {
    if (this == '') {
      return '';
    }
    return '$this ';
  }
}
