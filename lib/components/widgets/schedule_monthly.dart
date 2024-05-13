import 'package:flutter/material.dart';

import '../../models/schedule.dart';
import '../cards/scheduled_dosing_card.dart';

class ScheduleMonthly extends StatefulWidget {
  final Schedule schedule;
  const ScheduleMonthly({super.key, required this.schedule});

  @override
  State<ScheduleMonthly> createState() => _ScheduleMonthlyState();
}

class _ScheduleMonthlyState extends State<ScheduleMonthly> {
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
        buildDaysOfMonthSelector(),
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
    final list = <Widget>[];

    for (var i = 0; i < 31; i++) {
      final btn = SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
            onPressed: () {
              if (widget.schedule.monthPattern != null) {
                setState(() {
                  if (widget.schedule.monthPattern![i] == 0) {
                    widget.schedule.monthPattern![i] = 1;
                  } else {
                    widget.schedule.monthPattern![i] = 0;
                  }
                });
              }
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
    if (widget.schedule.monthPattern![index] == 1) {
      return Colors.amber;
    }
    return const Color.fromRGBO(255, 255, 193, 0.3);
  }

  Widget buildFrequency() {
    return Row(
      children: [
        DropdownButton<int>(
          value: widget.schedule.frequency.first,
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
              widget.schedule.frequency.first = value!;
            });
          },
        ),
      ],
    );
  }
}
