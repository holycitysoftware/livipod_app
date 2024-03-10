import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:livipod_app/controllers/ble_controller.dart';
import 'package:livipod_app/controllers/livi_pod_controller.dart';
import 'package:livipod_app/models/livi_pod.dart';
import 'package:livipod_app/views/schedule_view.dart';
import 'package:provider/provider.dart';

class DeviceView extends StatefulWidget {
  final LiviPod liviPod;
  final bool claim;
  const DeviceView({super.key, required this.liviPod, required this.claim});

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  late final LiviPodController _liviPodController;
  late final BleController _bleController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _claimed = false;
  bool _connected = false;
  bool _editName = false;
  late LiviPod liviPod;

  @override
  void initState() {
    _liviPodController = Provider.of<LiviPodController>(context, listen: false);
    _bleController = Provider.of<BleController>(context, listen: false);
    connect(widget.liviPod, widget.claim);
    liviPod = widget.liviPod;
    _claimed = !widget.claim;
    super.initState();
  }

  Future<void> connect(LiviPod liviPod, bool claim) async {
    if (claim) {
      final device =
          BluetoothDevice(remoteId: DeviceIdentifier(liviPod.remoteId));
      var bleDeviceController = _bleController.connect(device);
      liviPod.bleDeviceController = bleDeviceController;
    }
    liviPod.startBlink();
  }

  void disconnect() {
    if (!_claimed) {
      final device =
          BluetoothDevice(remoteId: DeviceIdentifier(liviPod.remoteId));
      _bleController.disconnect(device);
      liviPod.bleDeviceController = null;
    }
    liviPod.stopBlink();
  }

  @override
  void dispose() {
    _nameController.dispose();
    disconnect();
    super.dispose();
  }

  void pop() {
    Navigator.pop(context);
  }

  Future save() async {
    if (!_connected) {
      await showAlert();
    } else {
      // save to database
      liviPod.medicationName = _nameController.text;

      if (!await _liviPodController.liviPodExists(liviPod)) {
        liviPod = await _liviPodController.addLiviPod(liviPod);

        // write livipod id to device so nobody else can grab it
        liviPod.claim();
        if (mounted) {
          setState(() {
            _claimed = true;
          });
        }
      } else {
        await _liviPodController.updateLiviPod(liviPod);
        if (mounted) {
          setState(() {
            _editName = false;
          });
        }
      }
    }
  }

  Future clearClaim() async {
    if (!_connected) {
      await showAlert();
    } else {
      await liviPod.stopBlink();
      await liviPod.unclaim();
      _bleController.disconnect(liviPod.bleDeviceController!.bluetoothDevice);
      liviPod.bleDeviceController = null;
      await _liviPodController.removeLiviPod(liviPod);
      if (mounted) {
        setState(() {
          _nameController.clear();
          _claimed = false;
        });
      }
    }
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

  Future showUnclaimAlert() async {
    void pop() {
      Navigator.pop(context);
    }

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red[200],
            content: const Text(
              'This action will remove the medication and schedule from your LiviPod.  This action cannot be undone.  Are you sure you want to unclaim this device?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            title: const Text('Unclaim'),
            actions: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')),
                ElevatedButton(
                    onPressed: () async {
                      await clearClaim();
                      pop();
                    },
                    child: const Text('Yes'))
              ])
            ],
          );
        });
  }

  Future updateSchedule() async {
    await _liviPodController.updateLiviPod(liviPod);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BleController>(builder: (context, controller, child) {
      if (controller.connectedDevices.any((element) =>
          element.bluetoothDevice.remoteId.toString() == liviPod.remoteId)) {
        final bleDeviceController = controller.connectedDevices.firstWhere(
            (element) =>
                element.bluetoothDevice.remoteId.toString() ==
                liviPod.remoteId);
        _connected = bleDeviceController.bluetoothDevice.isConnected;
      } else {
        _connected = false;
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
                if (!_claimed || _editName) ...[
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      liviPod.medicationName,
                                      textAlign: TextAlign.center,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _nameController.text =
                                              liviPod.medicationName;
                                          if (mounted) {
                                            setState(() {
                                              _editName = true;
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.edit))
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (liviPod.schedule == null) ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return ScheduleView(
                                                  onAdd: (schedule) async {
                                                    liviPod.schedule = schedule;
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
                                    ],
                                  ),
                                ] else ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          liviPod.schedule!
                                              .getScheduleDescription(),
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return ScheduleView(
                                                  schedule: liviPod.schedule,
                                                  onAdd: (schedule) async {
                                                    liviPod.schedule = schedule;
                                                    await updateSchedule();
                                                  },
                                                  onUpdate: () async {
                                                    await updateSchedule();
                                                  },
                                                );
                                              },
                                            ));
                                          },
                                          icon: const Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () async {
                                            liviPod.schedule = null;
                                            await updateSchedule();
                                          },
                                          icon: const Icon(Icons.delete))
                                    ],
                                  )
                                ]
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await showUnclaimAlert();
                              },
                              child: const Text(
                                'Unclaim',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
              ]),
            ),
          ));
    });
  }
}
