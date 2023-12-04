import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/scheduled_dose.dart';

class ScheduledDosingCard extends StatefulWidget {
  final List<ScheduledDose> scheduledDosings;

  const ScheduledDosingCard({super.key, required this.scheduledDosings});

  @override
  State<ScheduledDosingCard> createState() => _ScheduledDosingCardState();
}

class _ScheduledDosingCardState extends State<ScheduledDosingCard> {
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    _qtyController.text = '1';
    _timeController.text = '08:00';
    widget.scheduledDosings
        .sort((a, b) => a.timeOfDay.hour.compareTo(b.timeOfDay.hour));
    super.initState();
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<TimeOfDay?> getTimeOfDay() async {
    return await showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 8, minute: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Take'),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 75,
                      child: TextField(
                        controller: _qtyController,
                        decoration:
                            const InputDecoration(label: Text('Quantity')),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]"))
                        ],
                      ),
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
                              if (t != null) {}
                            },
                            icon: const Icon(Icons.access_time))
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: IconButton(
                      onPressed: () {
                        double? qty = double.tryParse(_qtyController.text);
                        int? hour =
                            int.tryParse(_timeController.text.split(":")[0]);
                        int? minute =
                            int.tryParse(_timeController.text.split(":")[1]);
                        if (qty != null &&
                            hour != null &&
                            minute != null &&
                            !widget.scheduledDosings.any((element) =>
                                element.timeOfDay.hour == hour &&
                                element.timeOfDay.minute == minute)) {
                          var scheduledDose = ScheduledDose();
                          scheduledDose.qty = qty;
                          scheduledDose.timeOfDay =
                              TimeOfDay(hour: hour, minute: minute);
                          widget.scheduledDosings.add(scheduledDose);
                          widget.scheduledDosings.sort((a, b) =>
                              a.timeOfDay.hour.compareTo(b.timeOfDay.hour));
                        }
                        setState(() {});
                      },
                      icon: const Icon(Icons.add)),
                ),
              ],
            ),
          ),
        ),
        if (widget.scheduledDosings.isEmpty) ...[
          Column(
            children: const [
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
              var scheduledDose = widget.scheduledDosings[index];
              return Chip(
                label: Text(
                    '${scheduledDose.qty} at ${scheduledDose.timeOfDay.hour.toString().padLeft(2, '0')}:${scheduledDose.timeOfDay.minute.toString().padLeft(2, '0')}'),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 20,
                ),
                onDeleted: () {
                  widget.scheduledDosings.removeAt(index);
                  setState(() {});
                },
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
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
