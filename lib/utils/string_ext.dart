import 'package:intl/intl.dart';

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

extension StringExt on String {
  String extendText() {
    return replaceAll('', '\u{200B}');
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
