import 'package:flutter/material.dart';

import '../models/schedule.dart';
import 'scheduled_dosing_card.dart';

class ScheduleDaily extends StatefulWidget {
  final Schedule schedule;
  final Function onChange;
  const ScheduleDaily(
      {super.key, required this.onChange, required this.schedule});

  @override
  State<ScheduleDaily> createState() => _ScheduleDailyState();
}

class _ScheduleDailyState extends State<ScheduleDaily> {
  late Schedule _schedule;

  @override
  void initState() {
    _schedule = widget.schedule;
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
          onChange: widget.onChange,
          scheduledDosings: _schedule.scheduledDosings,
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
        DropdownButton(
          value: _schedule.frequency,
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
              _schedule.frequency = value!;
            });
          },
        ),
      ],
    );
  }
}
