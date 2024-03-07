import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:livipod_app/components/schedule_daily.dart';
import 'package:livipod_app/models/schedule.dart';
import '../components/schedule_as_needed.dart';
import '../components/schedule_monthly.dart';
import '../components/schedule_weekly.dart';
import '../models/schedule_type.dart';
import '../utils/utils.dart' as utils;

class ScheduleView extends StatefulWidget {
  final Schedule? schedule;
  final Function(Schedule) onAdd;
  final Function onUpdate;
  const ScheduleView(
      {super.key, this.schedule, required this.onAdd, required this.onUpdate});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late bool _isNew;
  late final Schedule _schedule;
  final TextEditingController _startDosingWindowController =
      TextEditingController();
  final TextEditingController _endDosingWindowController =
      TextEditingController();

  @override
  void initState() {
    if (widget.schedule == null) {
      _isNew = true;
      _schedule = Schedule();
      _schedule.type = ScheduleType.daily;
      _schedule.startDate = DateTime.now();
      _schedule.endDate = DateTime(_schedule.startDate.year + 1,
          _schedule.startDate.month, _schedule.startDate.day);
    } else {
      _isNew = false;
      _schedule = widget.schedule!;
    }

    super.initState();
  }

  Future<DateTime?> getDate(DateTime initialDate) async {
    return await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        currentDate: initialDate,
        lastDate: DateTime(initialDate.year + 5));
  }

  Future update() async {
    if (_isNew) {
      widget.onAdd(_schedule);
    } else {
      widget.onUpdate();
    }
  }

  void close() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Start date'),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              final dt = await getDate(_schedule.startDate);
                              if (dt != null) {
                                setState(() {
                                  _schedule.startDate = dt;
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_month)),
                        Text(utils.getFormattedDate(_schedule.startDate)),
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
                              final dt = await getDate(_schedule.endDate!);
                              if (dt != null) {
                                setState(() {
                                  _schedule.endDate = dt;
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_month)),
                        Text(utils.getFormattedDate(_schedule.endDate!)),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Schedule type'),
                    DropdownButton<ScheduleType>(
                        value: _schedule.type,
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
                            _schedule.type = scheduleType!;
                          });
                        })
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_schedule.type == ScheduleType.daily)
                  ScheduleDaily(
                    schedule: _schedule,
                    onChange: () {
                      setState(() {});
                    },
                  ),
                if (_schedule.type == ScheduleType.weekly)
                  ScheduleWeekly(schedule: _schedule),
                if (_schedule.type == ScheduleType.monthly)
                  ScheduleMonthly(schedule: _schedule),
                if (_schedule.type == ScheduleType.asNeeded)
                  ScheduleAsNeeded(schedule: _schedule),
                if (_schedule.type != ScheduleType.asNeeded) ...[
                  const Row(
                    children: [Text('The dosing window will open')],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    InputQty.int(
                      decoration: const QtyDecorationProps(
                        qtyStyle: QtyStyle.btnOnRight,
                      ),
                      maxVal: 720,
                      initVal: _schedule.startWarningMinutes,
                      minVal: 1,
                      steps: 1,
                      onQtyChanged: (val) {
                        setState(() {
                          _schedule.startWarningMinutes = val;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('minutes before'),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    children: [const Text('and close')],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      InputQty.int(
                        decoration: const QtyDecorationProps(
                          qtyStyle: QtyStyle.btnOnRight,
                        ),
                        maxVal: 720,
                        initVal: _schedule.stopWarningMinutes,
                        minVal: 1,
                        steps: 1,
                        onQtyChanged: (val) {
                          setState(() {
                            _schedule.stopWarningMinutes = val;
                          });
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('minutes after'),
                    ],
                  ),
                ],
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed:
                                  _schedule.type == ScheduleType.asNeeded ||
                                          _schedule.scheduledDosings.isNotEmpty
                                      ? () async {
                                          update();
                                          close();
                                        }
                                      : null,
                              child: _isNew
                                  ? const Text('Add')
                                  : const Text('Update')))
                    ],
                  )
                ],
              ),
            )
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
