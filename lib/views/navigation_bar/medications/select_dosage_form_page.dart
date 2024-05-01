import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';

class SelectDosageFormPageArguments {
  final Medication medication;
  SelectDosageFormPageArguments({required this.medication});
}

class SelectDosageFormPage extends StatefulWidget {
  static const String routeName = '/select-dosage-form-page';

  final Medication? medication;
  const SelectDosageFormPage({
    super.key,
    this.medication,
  });

  @override
  State<SelectDosageFormPage> createState() => _SelectDosageFormPageState();
}

class _SelectDosageFormPageState extends State<SelectDosageFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiviAppBar(
        title: widget.medication?.name ?? 'Select Dosage Form',
      ),
      body: Center(
        child: Text('Select Dosage Form Page'),
      ),
    );
  }
}
