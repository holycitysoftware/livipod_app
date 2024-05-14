import 'package:flutter/material.dart';

class ScheduledDose {
  double qty = 1;
  TimeOfDay timeOfDay = const TimeOfDay(hour: 8, minute: 0);

  ScheduledDose({
    this.qty = 1,
    required this.timeOfDay,
  });

  static ScheduledDose fromJson(Map<String, dynamic> json) {
    return ScheduledDose(
      qty: (json['qty'] as num?)?.toDouble() ?? 1,
      timeOfDay: TimeOfDay(
        hour: json['hour'] as int? ?? 8,
        minute: json['minute'] as int? ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'qty': qty,
      'hour': timeOfDay.hour,
      'minute': timeOfDay.minute,
    };
  }
}
