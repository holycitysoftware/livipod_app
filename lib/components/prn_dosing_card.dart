import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';

import '../models/prn_dose.dart';

class PrnDosingCard extends StatefulWidget {
  final PrnDose prnDose;
  final Function onChange;

  const PrnDosingCard(
      {super.key, required this.onChange, required this.prnDose});

  @override
  State<PrnDosingCard> createState() => _PrnDosingCardState();
}

class _PrnDosingCardState extends State<PrnDosingCard> {
  double _quantity = 1;
  int _interval = 4;
  double _nte = 8;

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
        Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Take'),
                    DecimalNumberPicker(
                      value: _quantity,
                      // axis: Axis.horizontal,
                      decimalPlaces: 1,
                      itemWidth: 40,
                      minValue: 1,
                      maxValue: 10,
                      onChanged: (value) => setState(() => _quantity = value),
                    ),
                    const Text('every'),
                    NumberPicker(
                      value: _interval,
                      axis: Axis.horizontal,
                      itemWidth: 40,
                      minValue: 1,
                      maxValue: 24,
                      onChanged: (value) => setState(() => _interval = value),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text('Do not exceed'),
                    DecimalNumberPicker(
                      value: _nte,
                      //axis: Axis.horizontal,
                      decimalPlaces: 2,
                      itemWidth: 40,
                      minValue: 1,
                      maxValue: 24,
                      onChanged: (value) => setState(() => _nte = value),
                    ),
                    const Text('per day.'),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
