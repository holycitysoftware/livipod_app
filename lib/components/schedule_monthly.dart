import 'package:flutter/material.dart';

import '../models/schedule.dart';
import 'scheduled_dosing_card.dart';

class ScheduleMonthly extends StatefulWidget {
  final Schedule schedule;
  final Function onChange;
  const ScheduleMonthly(
      {super.key, required this.onChange, required this.schedule});

  @override
  State<ScheduleMonthly> createState() => _ScheduleMonthlyState();
}

class _ScheduleMonthlyState extends State<ScheduleMonthly> {
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
        buildDaysOfMonthSelector(),
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

  Widget buildDaysOfMonthSelector() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      shrinkWrap: true,
      crossAxisCount: 7,
      childAspectRatio: 1,
      children: getDaysOfMonth(),
    );
  }

  List<Widget> getDaysOfMonth() {
    var list = <Widget>[];

    for (var i = 0; i < 31; i++) {
      var btn = SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (_schedule.monthPattern[i] == 0) {
                  _schedule.monthPattern[i] = 1;
                } else {
                  _schedule.monthPattern[i] = 0;
                }
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: getBackgroundColor(i)),
            child: Text(
              (i + 1).toString(),
              style: const TextStyle(fontSize: 10),
            )),
      );
      list.add(btn);
    }

    return list;
  }

  Color getBackgroundColor(int index) {
    if (_schedule.monthPattern[index] == 1) {
      return Colors.amber;
    }
    return const Color.fromRGBO(255, 255, 193, 0.3);
  }

  Widget buildFrequency() {
    return Row(
      children: [
        DropdownButton(
          value: _schedule.frequency,
          items: const [
            DropdownMenuItem(
              value: 1,
              child: Text('Every month on:'),
            ),
            DropdownMenuItem(
              value: 2,
              child: Text('Every other month on:'),
            ),
            DropdownMenuItem(
              value: 3,
              child: Text('Every three months on:'),
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
