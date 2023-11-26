import 'package:flutter/material.dart';
import 'package:livipod_app/models/livi_pod.dart';

class MedicationView extends StatefulWidget {
  final LiviPod liviPod;
  const MedicationView({super.key, required this.liviPod});

  @override
  State<MedicationView> createState() => _MedicationViewState();
}

class _MedicationViewState extends State<MedicationView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medication')),
      body: Padding(padding: const EdgeInsets.all(20)),
    );
  }
}
