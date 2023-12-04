import 'package:flutter/material.dart';

import '../models/prn_dose.dart';
import '../models/schedule.dart';
import 'prn_dosing_card.dart';

class ScheduleAsNeeded extends StatefulWidget {
  final Schedule schedule;
  const ScheduleAsNeeded({super.key, required this.schedule});

  @override
  State<ScheduleAsNeeded> createState() => _ScheduleAsNeededState();
}

class _ScheduleAsNeededState extends State<ScheduleAsNeeded> {
  @override
  void initState() {
    widget.schedule.prnDosing ??= PrnDose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        PrnDosingCard(prnDose: widget.schedule.prnDosing!)
      ],
    );
  }
}
