import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:livipod_app/controllers/devices_controller.dart';
import 'package:livipod_app/controllers/livi_pod_controller.dart';
import 'package:livipod_app/models/livi_pod.dart';
import 'package:livipod_app/views/schedule_view.dart';
import 'package:provider/provider.dart';

import '../models/schedule.dart';

class DeviceView extends StatefulWidget {
  final BluetoothDevice device;
  const DeviceView({super.key, required this.device});

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  late final LiviPodController _liviPodController;
  late final DevicesController _devicesController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _claimed = false;
  bool _connected = false;
  LiviPod? liviPod;

  @override
  void initState() {
    _liviPodController = Provider.of<LiviPodController>(context, listen: false);
    _liviPodController.listenToLiviPodsRealTime().listen(handleLiviPods);
    _devicesController = Provider.of<DevicesController>(context, listen: false);
    _devicesController.connect(widget.device);
    super.initState();
  }

  @override
  void dispose() {
    _liviPodController
        .listenToLiviPodsRealTime()
        .listen(handleLiviPods)
        .cancel();
    _nameController.dispose();
    _devicesController.disconnect(widget.device);
    super.dispose();
  }

  void handleLiviPods(List<LiviPod> liviPods) {
    for (final pod in liviPods) {
      if (pod.remoteId == widget.device.remoteId.toString()) {
        liviPod = pod;
        if (mounted) {
          setState(() {
            _claimed = true;
          });
        }
      }
    }
  }

  void pop() {
    Navigator.pop(context);
  }

  Future save() async {
    if (!_connected) {
      await showAlert();
    } else {
      // save to database
      var liviPod = LiviPod(
          remoteId: widget.device.remoteId.toString(),
          medicationName: _nameController.text);
      if (!await _liviPodController.liviPodExists(liviPod)) {
        liviPod = await _liviPodController.addLiviPod(liviPod);
        // write livipod id to device so nobody else can grab it
        await _devicesController.claim(widget.device, liviPod.id);
      } else {
        await showError();
      }
    }
  }

  Future clearClaim() async {
    if (!_connected) {
      await showAlert();
    } else {
      await _devicesController.unclaim(widget.device);
      await _liviPodController.removeLiviPod(liviPod!);
      if (mounted) {
        setState(() {
          _claimed = false;
          liviPod = null;
        });
      }
    }
  }

  Future showError() async {
    await showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('This Pod has already been claimied'),
          );
        });
  }

  Future showAlert() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              'The Pod is not connected.  Please make sure you are in proximity and the Pod is plugged in.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            title: const Text('No Connection'),
            actions: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Ok'))
              ])
            ],
          );
        });
  }

  Future updateSchedule() async {
    await _liviPodController.updateLiviPod(liviPod!);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DevicesController>(builder: (context, controller, child) {
      _connected = widget.device.isConnected;

      if (controller.connectedDevices
          .any((element) => element.remoteId == widget.device.remoteId)) {
        _connected = true;
      }
      return Scaffold(
          appBar: AppBar(
            title: const Text('LiviPod'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.circle,
                  color: _connected ? Colors.green : Colors.red,
                ),
              )
            ],
          ),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                if (!_claimed) ...[
                  Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              label: Text('Medication Name')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a medication';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );

                            await save();
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (liviPod != null &&
                              liviPod!.schedules.isEmpty) ...[
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ScheduleView(
                                        onAdd: (schedule) async {
                                          liviPod!.schedules.add(schedule);
                                          await updateSchedule();
                                        },
                                        onUpdate: () async {
                                          await updateSchedule();
                                        },
                                      );
                                    },
                                  ));
                                },
                                child: const Text('Add a schedule'))
                          ] else ...[
                            Text('there is a schedule')
                          ]
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                                'LiviPod ${liviPod?.id} has been claimed by you and associated with ${liviPod?.medicationName}.  Tap the Unclaim button below if you want to remove the medication assigment and association to your account.'),
                          )
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await clearClaim();
                        },
                        child: const Text(
                          'Unclaim',
                        ),
                      ),
                    ],
                  ),
                ]
              ]),
            ),
          ));
    });
  }
}
