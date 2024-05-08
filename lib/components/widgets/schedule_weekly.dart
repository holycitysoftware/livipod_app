import 'package:flutter/material.dart';
import '../../models/schedule.dart';
import '../../utils/utils.dart' as utils;
import '../cards/scheduled_dosing_card.dart';

class ScheduleWeekly extends StatefulWidget {
  final Schedule schedule;
  const ScheduleWeekly({super.key, required this.schedule});

  @override
  State<ScheduleWeekly> createState() => _ScheduleWeeklyState();
}

class _ScheduleWeeklyState extends State<ScheduleWeekly> {
  @override
  void initState() {
    super.initState();
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
        buildDaysOfWeekSelector(),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
        const SizedBox(
          height: 10,
        ),
        ScheduledDosingCard(
          scheduledDosings: widget.schedule.scheduledDosings,
          onChange: () {
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

  Widget buildDaysOfWeekSelector() {
    return Wrap(
      spacing: 10,
      alignment: WrapAlignment.center,
      children: getDaysOfWeek(),
    );
  }

  List<Widget> getDaysOfWeek() {
    final list = <Widget>[];

    for (var i = 0; i < 7; i++) {
      final btn = SizedBox(
        width: 90,
        child: ElevatedButton(
            onPressed: () {
              if (widget.schedule.dayPattern != null) {
                setState(() {
                  if (widget.schedule.dayPattern![i] == 0) {
                    widget.schedule.dayPattern![i] = 1;
                  } else {
                    widget.schedule.dayPattern![i] = 0;
                  }
                });
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: getBackgroundColor(i)),
            child: Text(
              utils.getDay(i),
              style: const TextStyle(fontSize: 10),
            )),
      );
      list.add(btn);
    }

    return list;
  }

  Widget buildFrequency() {
    return Row(
      children: [
        DropdownButton(
          value: widget.schedule.frequency,
          items: const [
            DropdownMenuItem(
              value: 1,
              child: Text('Every week on:'),
            ),
            DropdownMenuItem(
              value: 2,
              child: Text('Every other week on:'),
            ),
            DropdownMenuItem(
              value: 3,
              child: Text('Every three weeks on:'),
            )
          ],
          onChanged: (value) {
            setState(() {
              widget.schedule.frequency = value!;
            });
          },
        ),
      ],
    );
  }

  Color getBackgroundColor(int index) {
    if (widget.schedule.dayPattern?[index] == 1) {
      return Colors.amber;
    }
    return const Color.fromRGBO(255, 255, 193, 0.3);
  }
}
