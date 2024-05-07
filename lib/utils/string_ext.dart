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
}

extension StringExt on String {
  String extendText() {
    return replaceAll('', '\u{200B}');
  }

  String requiredSymbol() {
    return '$this*';
  }

  String getFirstLetter() {
    return this[0];
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
