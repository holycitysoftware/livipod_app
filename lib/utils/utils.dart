import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/enums.dart';
import '../themes/livi_themes.dart';

int daysBetween(DateTime end, DateTime start) {
  return (end.difference(start).inHours / 24).round();
}

String getFormattedDate(DateTime? date) {
  if (date != null) {
    return DateFormat('MM/dd/yy').format(date);
  }
  return 'Never';
}

Widget dosageFormIcon({required DosageForm dosageForm, Color? color}) {
  switch (dosageForm) {
    case DosageForm.none:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.capsule:
      return LiviThemes.icons.capsuleIcon(color: color);
    case DosageForm.tablet:
      return LiviThemes.icons.tabletIcon(color: color);
    case DosageForm.drops:
      return LiviThemes.icons.dropsIcon(color: color);
    case DosageForm.injection:
      return LiviThemes.icons.injectionIcon(color: color);
    case DosageForm.ointment:
      return LiviThemes.icons.ointmentIcon(color: color);
    case DosageForm.liquid:
      return LiviThemes.icons.liquidIcon(color: color);
    case DosageForm.patch:
      return LiviThemes.icons.patchIcon(color: color);
    case DosageForm.other:
      return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
  }
}

String getStringFromDateTimeInteger(int day) {
  switch (day) {
    case 1:
      return 'Sunday';
    case 2:
      return 'Monday';

    case 3:
      return 'Tuesday';
    case 4:
      return 'Wednesday';
    case 5:
      return 'Thursday';
    case 6:
      return 'Friday';
    case 7:
      return 'Saturday';
    default:
      return '';
  }
}

String getFormattedTime(DateTime? date) {
  if (date != null) {
    return DateFormat('h:mm a').format(date);
  } else {
    return '-';
  }
}

String getFormattedLocalDateAndTime(DateTime? date) {
  if (date != null) {
    date = date.toLocal();
    return DateFormat('MM/dd/yy h:mm a').format(date);
  }
  return 'Never';
}

String getFormattedDateAndTime(DateTime? date) {
  if (date != null) {
    return DateFormat('MM/dd/yy h:mm a').format(date);
  }
  return 'Never';
}

String removeDecimalZeroFormat(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
}

String getDay(int index) {
  switch (index) {
    case 0:
      return 'Sunday';
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    default:
      return 'Unknown';
  }
}

String formartDay(int day) {
  switch (day) {
    case 1:
      return '1st';
    case 2:
      return '2nd';
    case 3:
      return '3rd';
    default:
      return '${day}th';
  }
}

String formartTimeOfDay(TimeOfDay timeOfDat) {
  //ap pm hour
  String ap = timeOfDat.period == DayPeriod.am ? 'AM' : 'PM';
  String hour = timeOfDat.hourOfPeriod.toString();
  String minute = timeOfDat.minute.toString();
  hour = hour;
  if (timeOfDat.minute < 10) {
    minute = '0$minute';
  }
  return '$hour:$minute $ap';
}
