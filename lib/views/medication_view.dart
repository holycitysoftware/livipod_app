import 'package:flutter/material.dart';
import 'package:livipod_app/controllers/livi_pod_controller.dart';
import 'package:livipod_app/models/livi_pod.dart';
import 'package:provider/provider.dart';

import '../models/medication.dart';

class MedicationView extends StatefulWidget {
  final LiviPod liviPod;
  const MedicationView({super.key, required this.liviPod});

  @override
  State<MedicationView> createState() => _MedicationViewState();
}

class _MedicationViewState extends State<MedicationView> {
  MedicationState _state = MedicationState.none;
  final _medicationNameKey = GlobalKey<FormState>();
  final TextEditingController _medNameController = TextEditingController();
  late final LiviPodController _liviPodController;

  @override
  void initState() {
    _liviPodController = Provider.of<LiviPodController>(context, listen: false);
    if (widget.liviPod.medication != null) {
      if (widget.liviPod.medication!.name.isNotEmpty &&
          widget.liviPod.medication!.schedules.isEmpty) {
        _state = MedicationState.named;
        _medNameController.text = widget.liviPod.medication!.name;
      } else if (widget.liviPod.medication!.name.isNotEmpty &&
          widget.liviPod.medication!.schedules.isNotEmpty) {
        _state = MedicationState.scheduled;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _medNameController.dispose();
    super.dispose();
  }

  Future saveName() async {
    widget.liviPod.medication = Medication();
    widget.liviPod.medication!.name = _medNameController.text;
    await _liviPodController.updateLiviPod(widget.liviPod);
    setState(() {
      _state = MedicationState.named;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medication')),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (_state == MedicationState.none) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _state = MedicationState.naming;
                          });
                        },
                        child: const Text('Add medication'))
                  ],
                )
              ] else if (_state == MedicationState.naming) ...[
                Form(
                    key: _medicationNameKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _medNameController,
                          decoration:
                              const InputDecoration(label: Text('name')),
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_medicationNameKey.currentState!
                                    .validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Saving name')),
                                  );

                                  await saveName();
                                }
                              },
                              child: const Text('Continue'),
                            )
                          ],
                        ),
                      ],
                    ))
              ] else if (_state == MedicationState.named) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.liviPod.medication!.name),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _state = MedicationState.naming;
                          });
                        },
                        icon: const Icon(Icons.edit))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _state = MedicationState.scheduling;
                        });
                      },
                      child: const Text('Add a schedule'),
                    )
                  ],
                ),
              ]
            ],
          )),
    );
  }
}

enum MedicationState { none, naming, named, scheduling, scheduled }
