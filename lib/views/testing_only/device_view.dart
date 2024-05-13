import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../models/livi_pod.dart';

class DeviceView extends StatefulWidget {
  final LiviPod liviPod;
  final bool claim;
  const DeviceView({super.key, required this.liviPod, required this.claim});

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  late final AuthController _authController;
  final LiviPodService _liviPodService = LiviPodService();
  late final BleController _bleController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _claimed = false;
  bool _connected = false;
  bool _editName = false;
  late LiviPod liviPod;
  bool _dispensing = false;

  @override
  void initState() {
    _authController = Provider.of<AuthController>(context, listen: false);
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
      final bleDeviceController =
          _bleController.connectToUnclaimedDevice(device);
      liviPod.bleDeviceController = bleDeviceController;
    } else {
      liviPod.connect();
    }
  }

  void disconnect() {
    if (!_claimed) {
      final device =
          BluetoothDevice(remoteId: DeviceIdentifier(liviPod.remoteId));
      _bleController.stopBlinkOnUnclaimedDevice(device);
      _bleController.disconnectFromUnclaimedDevice(device);
      liviPod.bleDeviceController = null;
    } else {
      liviPod.stopBlink();
      liviPod.disconnect();
    }
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
      liviPod.userId = 'billy_boy';
      if (!await _liviPodService.liviPodExists(liviPod)) {
        liviPod = await _liviPodService.addLiviPod(liviPod);

        // write livipod id to device so nobody else can grab it
        liviPod.claim();
        if (mounted) {
          setState(() {
            _claimed = true;
          });
        }
      } else {
        await _liviPodService.updateLiviPod(liviPod);
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
      _bleController.disconnectFromUnclaimedDevice(
          liviPod.bleDeviceController!.bluetoothDevice);
      liviPod.bleDeviceController = null;
      await _liviPodService.removeLiviPod(liviPod);
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

  Future showResetAlert() async {
    void pop() {
      Navigator.pop(context);
    }

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.red[200],
            content: const Text(
              'This action will remove this LiviPod from your account and reset the firmware.  This action cannot be undone.  Are you sure you want to reset this device?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            title: const Text('Reset'),
            actions: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No')),
                ElevatedButton(
                    onPressed: () async {
                      await reset();
                      pop();
                    },
                    child: const Text('Yes'))
              ])
            ],
          );
        });
  }

  // Future updateSchedule() async {
  //   await _liviPodController.updateLiviPod(liviPod);
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  Future<void> reset() async {
    if (!_connected) {
      await showAlert();
    } else {
      await liviPod.stopBlink();
      await liviPod.unclaim();
      await liviPod.reset();
      _bleController.disconnectFromUnclaimedDevice(
          liviPod.bleDeviceController!.bluetoothDevice);
      liviPod.bleDeviceController = null;
      await _liviPodService.removeLiviPod(liviPod);
      if (mounted) {
        setState(() {
          _nameController.clear();
          _claimed = false;
        });
      }
    }
  }

  Future dispense(int qty) async {
    if (!_connected) {
      await showAlert();
    } else {
      final dr = DispenseRequest(
          bleDeviceController: liviPod.bleDeviceController!,
          event: 'dispensing',
          requested: qty,
          dispensed: 0,
          status: '');
      await liviPod.dispense(dr);
      setState(() {
        _dispensing = true;
      });
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
        if (bleDeviceController.readyForCommands) {
          liviPod.startBlink();
        }
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
                if (!_dispensing && (!_claimed || _editName)) ...[
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Claiming pod')),
                          );

                          await save();
                        },
                        child: const Text('Claim'),
                      ),
                    ],
                  ),
                ] else if (!_dispensing) ...[
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            dispense(5);
                          },
                          child: const Text(
                            'Test Dispense',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await showUnclaimAlert();
                          },
                          child: const Text(
                            'Unclaim',
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await showResetAlert();
                          },
                          child: const Text(
                            'Reset Pod',
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (_dispensing)
                  ...[]
              ]),
            ),
          ));
    });
  }
}
