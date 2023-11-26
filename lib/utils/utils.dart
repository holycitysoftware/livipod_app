import 'package:intl/intl.dart';

int daysBetween(DateTime end, DateTime start) {
  return (end.difference(start).inHours / 24).round();
}

String getFormattedDate(DateTime? date) {
  if (date != null) {
    return DateFormat('MM/dd/yy').format(date);
  }
  return 'Never';
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
