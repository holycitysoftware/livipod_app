import 'package:flutter/material.dart';

class SelectMedicationStrength extends StatelessWidget {
  static const String routeName = '/select-medication-strength-page';
  const SelectMedicationStrength({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Medication Strength'),
      ),
      body: Center(
        child: Text('Select Medication Strength Page'),
      ),
    );
  }
}
