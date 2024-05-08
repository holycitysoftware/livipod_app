import 'package:json_annotation/json_annotation.dart';

import '../utils/utils.dart' as utils;
import 'enums.dart';
import 'prn_dose.dart';
import 'schedule_type.dart';
import 'scheduled_dose.dart';

part 'schedule.g.dart';

@JsonSerializable(explicitToJson: true)
class Schedule {
  DateTime startDate = DateTime.now();
  DateTime? endDate;
  ScheduleType type;
  IntervalBetweenDoses intervalBetweenDoses;
  int frequency;
  // List.generate(7, (index) => index + 1, growable: false);
  List<int>? dayPattern;
  // List.generate(31, (index) => index + 1, growable: false);
  List<int>? monthPattern;
  List<ScheduledDose> scheduledDosings = [];
  PrnDose? prnDosing;
  TimeReminderBefore timeReminderBefore;
  TimeReminderLater timeReminderLater;
  String instructions = '';

  Schedule({
    this.endDate,
    this.type = ScheduleType.daily,
    this.timeReminderBefore = TimeReminderBefore.fiveMinutes,
    this.timeReminderLater = TimeReminderLater.fiveMinutes,
    this.intervalBetweenDoses = IntervalBetweenDoses.eightHours,
    this.instructions = '',
    this.frequency = 1,
    this.dayPattern,
    this.monthPattern,
    required this.scheduledDosings,
    this.prnDosing,
  });

  String getScheduleDescription() {
    // var scheduleType = getScheduleType();
    var str = 'Take';
    if (type != ScheduleType.asNeeded) {
      for (final dosing in scheduledDosings) {
        str =
            '$str ${utils.removeDecimalZeroFormat(dosing.qty)} at ${dosing.timeOfDay.hour.toString().padLeft(2, '0')}:${dosing.timeOfDay.minute.toString().padLeft(2, '0')},';
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

        if (dayPattern != null && !dayPattern!.any((element) => element == 0)) {
          str = '$str $freqStr.';
        } else {
          var dayStr = '$freqStr on';
          for (var day = 0; day < dayPattern!.length; day++) {
            if (dayPattern![day] == 1) {
              final d = utils.getDay(day).toLowerCase();
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

        if (monthPattern != null &&
            !monthPattern!.any((element) => element == 0)) {
          str = '$str $freqStr each day.';
        } else {
          var dayStr = '$freqStr on day';
          for (var day = 0; day < monthPattern!.length; day++) {
            if (monthPattern![day] == 1) {
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
