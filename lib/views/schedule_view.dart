import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livipod_app/components/schedule_daily.dart';
import 'package:livipod_app/models/schedule.dart';
import '../components/schedule_as_needed.dart';
import '../components/schedule_monthly.dart';
import '../components/schedule_weekly.dart';
import '../models/livi_pod.dart';
import '../models/schedule_type.dart';
import '../utils/utils.dart' as utils;

class ScheduleView extends StatefulWidget {
  final LiviPod liviPod;
  Schedule? schedule;
  ScheduleView({super.key, required this.liviPod, this.schedule});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  ScheduleType _scheduleType = ScheduleType.daily;
  late DateTime _startDate;
  late DateTime _endDate;
  late Schedule _schedule;
  final TextEditingController _startDosingWindowController =
      TextEditingController();
  final TextEditingController _endDosingWindowController =
      TextEditingController();

  @override
  void initState() {
    _schedule = widget.schedule ?? Schedule();
    _startDate = DateTime.now();
    _endDate = DateTime(_startDate.year + 1, _startDate.month, _startDate.day);
    super.initState();
  }

  Future<DateTime?> getDate(DateTime initialDate) async {
    return await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        currentDate: initialDate,
        lastDate: DateTime(initialDate.year + 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Start date'),
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          final dt = await getDate(_startDate);
                          if (dt != null) {
                            setState(() {
                              _startDate = dt;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_month)),
                    Text(utils.getFormattedDate(_startDate)),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('End date'),
                Row(
                  children: [
                    IconButton(
                        onPressed: () async {
                          final dt = await getDate(_endDate);
                          if (dt != null) {
                            setState(() {
                              _endDate = dt;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_month)),
                    Text(utils.getFormattedDate(_endDate)),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Schedule type'),
                DropdownButton<ScheduleType>(
                    value: _scheduleType,
                    items: const [
                      DropdownMenuItem(
                        value: ScheduleType.daily,
                        child: Text('Daily'),
                      ),
                      DropdownMenuItem(
                        value: ScheduleType.asNeeded,
                        child: Text('As-needed'),
                      )
                    ],
                    onChanged: (scheduleType) {
                      setState(() {
                        _scheduleType = scheduleType!;
                      });
                    })
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (_scheduleType == ScheduleType.daily)
              ScheduleDaily(schedule: _schedule, onChange: () {}),
            if (_scheduleType == ScheduleType.weekly)
              ScheduleWeekly(schedule: _schedule, onChange: () => {}),
            if (_scheduleType == ScheduleType.monthly)
              ScheduleMonthly(schedule: _schedule, onChange: () => {}),
            if (_scheduleType == ScheduleType.asNeeded)
              ScheduleAsNeeded(schedule: _schedule, onChange: () => {}),
            if (_scheduleType != ScheduleType.asNeeded) ...[
              buildStartDosingWindow(),
              buildEndDosingWindow(),
            ],
          ])),
    );
  }

  Widget buildStartDosingWindow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Window opens'),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 50,
          child: TextField(
            textAlign: TextAlign.right,
            controller: _startDosingWindowController,
            // decoration:
            //     const InputDecoration(label: Text('minutes before.')),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              var startWarningMinutes =
                  int.tryParse(_startDosingWindowController.text);
              if (startWarningMinutes != null) {
                _schedule.startWarningMinutes = startWarningMinutes;
              }
            },
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        const Text('minutes before.'),
      ],
    );
  }

  Widget buildEndDosingWindow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Window ends'),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 50,
          child: TextField(
            textAlign: TextAlign.right,
            controller: _endDosingWindowController,
            // decoration:
            //     const InputDecoration(label: Text('minutes after due time')),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              var stopWarningMinutes =
                  int.tryParse(_endDosingWindowController.text);
              if (stopWarningMinutes != null) {
                _schedule.stopWarningMinutes = stopWarningMinutes;
              }
            },
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        const Text('minutes after.'),
      ],
    );
  }
}
