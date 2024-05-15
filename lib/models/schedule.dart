import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart' as utils;
import 'models.dart';
import 'schedule_type.dart';

part 'schedule.g.dart';

@JsonSerializable(explicitToJson: true)
class Schedule {
  @JsonKey(toJson: startDateToJson)
  DateTime startDate = DateTime.now();
  @JsonKey(toJson: endDateToJson)
  DateTime endDate = DateTime.now();
  ScheduleType type = ScheduleType.daily;
  List<int> frequency = [1];
  List<int> dayPattern = [1, 1, 1, 1, 1, 1, 1];
  List<int> monthPattern = [
    1,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];
  @JsonKey(
    fromJson: scheduledDosingsFromJson,
  )
  List<ScheduledDose> scheduledDosings = [];
  PrnDose? prnDosing;
  int startWarningMinutes = 60;
  int stopWarningMinutes = 60;

  Schedule({
    required this.endDate,
    required this.startDate,
    required this.scheduledDosings,
    this.prnDosing,
  });

  static List<ScheduledDose> scheduledDosingsFromJson(List<dynamic> json) {
    return json
        .map((e) => ScheduledDose.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static String startDateToJson(DateTime date) {
    return DateTime(date.year, date.month, date.day).toIso8601String();
  }

  static String? endDateToJson(DateTime? date) {
    if (date != null) {
      return date.toIso8601String();
    }
    return null;
  }

  String getScheduleDescription() {
    // var scheduleType = getScheduleType();
    var str = 'Take';
    if (type != ScheduleType.asNeeded) {
      if (scheduledDosings != null) {
        for (final dosing in scheduledDosings) {
          str =
              '$str ${utils.removeDecimalZeroFormat(dosing.qty)} at ${dosing.timeOfDay.hour.toString().padLeft(2, '0')}:${dosing.timeOfDay.minute.toString().padLeft(2, '0')},';
        }
      }

      if (type == ScheduleType.daily) {
        var freqStr = 'daily';
        if (frequency == 2) {
          freqStr = 'every other day';
        } else if (frequency == 3) {
          freqStr = 'every third day';
        }
        str = '$str $freqStr.';
      }

      if (type == ScheduleType.weekly) {
        var freqStr = 'every week';
        if (frequency == 2) {
          freqStr = 'every other week';
        } else if (frequency == 3) {
          freqStr = 'every three weeks';
        }

        if (!dayPattern.any((element) => element == 0)) {
          str = '$str $freqStr.';
        } else {
          var dayStr = '$freqStr on';
          for (var day = 0; day < dayPattern.length; day++) {
            if (dayPattern[day] == 1) {
              var d = utils.getDay(day).toLowerCase();
              dayStr = '$dayStr $d,';
            }
          }

          str = '$str $dayStr';
        }
      }

      if (type == ScheduleType.monthly) {
        var freqStr = 'every month';
        if (frequency == 2) {
          freqStr = 'every other month';
        } else if (frequency == 3) {
          freqStr = 'every three months';
        }

        if (!monthPattern.any((element) => element == 0)) {
          str = '$str $freqStr each day.';
        } else {
          var dayStr = '$freqStr on day';
          for (var day = 0; day < monthPattern.length; day++) {
            if (monthPattern[day] == 1) {
              var d = (day + 1).toString();
              dayStr = '$dayStr $d,';
            }
          }

          str = '$str $dayStr';
        }
      }
      return str;
    }
    return _getAsNeededDescription();
  }

  String _getAsNeededDescription() {
    var str =
        'Take ${utils.removeDecimalZeroFormat(prnDosing!.maxQty)} every ${prnDosing!.hourInterval} hours as needed.  Do not exceed ${utils.removeDecimalZeroFormat(prnDosing!.nteQty)} per day.';
    return str;
  }

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
