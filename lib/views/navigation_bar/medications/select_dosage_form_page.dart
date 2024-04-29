import 'package:flutter/material.dart';

class SelectDosageFormPage extends StatefulWidget {
  const SelectDosageFormPage({super.key});

  @override
  State<SelectDosageFormPage> createState() => _SelectDosageFormPageState();
}

class _SelectDosageFormPageState extends State<SelectDosageFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Dosage Form'),
      ),
      body: Center(
        child: Text('Select Dosage Form Page'),
      ),
    );
  }
}
