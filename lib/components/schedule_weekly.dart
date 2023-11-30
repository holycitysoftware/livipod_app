import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../utils/utils.dart' as utils;
import 'scheduled_dosing_card.dart';

class ScheduleWeekly extends StatefulWidget {
  final Schedule schedule;
  final Function onChange;
  const ScheduleWeekly(
      {super.key, required this.onChange, required this.schedule});

  @override
  State<ScheduleWeekly> createState() => _ScheduleWeeklyState();
}

class _ScheduleWeeklyState extends State<ScheduleWeekly> {
  late Schedule _schedule;

  @override
  void initState() {
    _schedule = widget.schedule;
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

  Widget buildDaysOfWeekSelector() {
    return Wrap(
      spacing: 10,
      alignment: WrapAlignment.center,
      children: getDaysOfWeek(),
    );
  }

  List<Widget> getDaysOfWeek() {
    var list = <Widget>[];

    for (var i = 0; i < 7; i++) {
      var btn = SizedBox(
        width: 90,
        child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (_schedule.dayPattern[i] == 0) {
                  _schedule.dayPattern[i] = 1;
                } else {
                  _schedule.dayPattern[i] = 0;
                }
              });
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
          value: _schedule.frequency,
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
              _schedule.frequency = value!;
            });
          },
        ),
      ],
    );
  }

  Color getBackgroundColor(int index) {
    if (_schedule.dayPattern[index] == 1) {
      return Colors.amber;
    }
    return const Color.fromRGBO(255, 255, 193, 0.3);
  }
}
