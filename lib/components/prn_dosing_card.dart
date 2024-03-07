import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';

import '../models/prn_dose.dart';

class PrnDosingCard extends StatefulWidget {
  final PrnDose prnDose;

  const PrnDosingCard({super.key, required this.prnDose});

  @override
  State<PrnDosingCard> createState() => _PrnDosingCardState();
}

class _PrnDosingCardState extends State<PrnDosingCard> {
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Take'),
                    InputQty.int(
                      decoration: const QtyDecorationProps(
                        qtyStyle: QtyStyle.btnOnRight,
                      ),
                      maxVal: 10,
                      initVal: widget.prnDose.maxQty,
                      minVal: 1,
                      steps: 1,
                      decimalPlaces: 0,
                      onQtyChanged: (val) {
                        setState(() {
                          widget.prnDose.maxQty = val.toDouble();
                        });
                      },
                    ),
                    const Text('every'),
                    InputQty.int(
                      decoration: const QtyDecorationProps(
                        qtyStyle: QtyStyle.btnOnRight,
                      ),
                      maxVal: 24,
                      initVal: widget.prnDose.hourInterval,
                      minVal: 1,
                      steps: 1,
                      onQtyChanged: (val) {
                        setState(() {
                          widget.prnDose.hourInterval = val;
                        });
                      },
                    ),
                    const Text('hours'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Do not exceed'),
                    InputQty.int(
                      decoration: const QtyDecorationProps(
                        qtyStyle: QtyStyle.btnOnRight,
                      ),
                      maxVal: 24,
                      initVal: widget.prnDose.nteQty,
                      minVal: 1,
                      steps: 1,
                      decimalPlaces: 0,
                      onQtyChanged: (val) {
                        setState(() {
                          widget.prnDose.nteQty = val.toDouble();
                        });
                      },
                    ),
                    const Text('per day'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
