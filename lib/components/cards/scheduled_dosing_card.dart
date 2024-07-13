import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../models/scheduled_dose.dart';
import '../../utils/utils.dart' as utils;

class ScheduledDosingCard extends StatefulWidget {
  final List<ScheduledDose> scheduledDosings;
  final Function onChange;

  const ScheduledDosingCard(
      {super.key, required this.scheduledDosings, required this.onChange});

  @override
  State<ScheduledDosingCard> createState() => _ScheduledDosingCardState();
}

class _ScheduledDosingCardState extends State<ScheduledDosingCard> {
  int _quantity = 1;
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    widget.scheduledDosings
        .sort((a, b) => a.timeOfDay.hour.compareTo(b.timeOfDay.hour));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<TimeOfDay?> getTimeOfDay() async {
    return showTimePicker(context: context, initialTime: _timeOfDay);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Take'),
                    const SizedBox(
                      width: 10,
                    ),
                    InputQty.int(
                      decoration: const QtyDecorationProps(
                        qtyStyle: QtyStyle.btnOnRight,
                      ),
                      maxVal: 99,
                      initVal: _quantity,
                      minVal: 1,
                      steps: 1,
                      onQtyChanged: (val) {
                        setState(() {
                          _quantity = val as int;
                        });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('at'),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              final t = await getTimeOfDay();
                              if (t != null) {
                                setState(() {
                                  _timeOfDay = t;
                                });
                              }
                            },
                            icon: const Icon(Icons.access_time)),
                        Text(_timeOfDay.format(context))
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: IconButton(
                      onPressed: () {
                        double? qty = _quantity.toDouble();
                        int hour = _timeOfDay.hour;

                        int minute = _timeOfDay.minute;
                        if (!widget.scheduledDosings.any((element) =>
                            element.timeOfDay.hour == hour &&
                            element.timeOfDay.minute == minute)) {
                          var scheduledDose =
                              ScheduledDose(timeOfDay: TimeOfDay.now());
                          scheduledDose.qty = qty;
                          scheduledDose.timeOfDay =
                              TimeOfDay(hour: hour, minute: minute);
                          widget.scheduledDosings.add(scheduledDose);
                          widget.scheduledDosings.sort((a, b) =>
                              a.timeOfDay.hour.compareTo(b.timeOfDay.hour));
                        }
                        widget.onChange();
                        setState(() {});
                      },
                      icon: const Icon(Icons.add)),
                ),
              ],
            ),
          ),
        ),
        if (widget.scheduledDosings.isEmpty) ...[
          const Column(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                'Click the + icon to add a dosing',
                style: TextStyle(color: Colors.amber),
              )
            ],
          )
        ],
        if (widget.scheduledDosings.isNotEmpty) ...[
          const SizedBox(
            width: 20,
          ),
          GridView.builder(
            itemCount: widget.scheduledDosings.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final scheduledDose = widget.scheduledDosings[index];
              return Chip(
                label: Text(
                    '${scheduledDose.qty} at ${utils.formartTimeOfDay(widget.scheduledDosings[index].timeOfDay, Provider.of<AuthController>(context).appUser!.useMilitaryTime)}'),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 20,
                ),
                onDeleted: () {
                  widget.scheduledDosings.removeAt(index);
                  setState(() {});
                  widget.onChange();
                },
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              mainAxisExtent: 50,
            ),
          )
        ]
      ],
    );
  }
}
