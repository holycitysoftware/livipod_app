import 'package:flutter/material.dart';

import '../../models/schedule.dart';
import '../cards/scheduled_dosing_card.dart';

class ScheduleDaily extends StatefulWidget {
  final Schedule schedule;
  final Function onChange;
  const ScheduleDaily(
      {super.key, required this.schedule, required this.onChange});

  @override
  State<ScheduleDaily> createState() => _ScheduleDailyState();
}

class _ScheduleDailyState extends State<ScheduleDaily> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildFrequency(),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
        const SizedBox(
          height: 10,
        ),
        ScheduledDosingCard(
          scheduledDosings: widget.schedule.scheduledDosings,
          useMilitaryTime: true,
          onChange: () {
            widget.onChange();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
      ],
    );
  }

  Widget buildFrequency() {
    return Row(
      children: [
        DropdownButton<int>(
          value: widget.schedule.frequency.first,
          items: const [
            DropdownMenuItem(
              value: 1,
              child: Text('Every day'),
            ),
            DropdownMenuItem(
              value: 2,
              child: Text('Every other day'),
            ),
            DropdownMenuItem(
              value: 3,
              child: Text('Every 3 days'),
            )
          ],
          onChanged: (value) {
            setState(() {
              widget.schedule.frequency.first = value!;
            });
          },
        ),
      ],
    );
  }
}
