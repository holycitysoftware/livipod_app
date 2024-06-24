import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';
import '../controllers/controllers.dart';
import '../models/livi_pod.dart';
import '../services/livi_pod_service.dart';
import '../themes/livi_themes.dart';
import '../utils/strings.dart';

class DeviceView extends StatefulWidget {
  final LiviPod liviPod;
  final bool claim;
  const DeviceView({super.key, required this.liviPod, required this.claim});

  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  late final AuthController _authController;
  final LiviPodService _liviPodController = LiviPodService();
  late final BleController _bleController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _claimed = false;
  bool _connected = false;
  bool _editName = false;
  late LiviPod liviPod;

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
      var bleDeviceController = _bleController.connectToUnclaimedDevice(device);
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
      liviPod.appUserId = _authController.appUser!.id;
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
      _bleController.disconnectFromUnclaimedDevice(
          liviPod.bleDeviceController!.bluetoothDevice);
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
    // await showCupertinoModalPopup<void>(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: LiviTextStyles.interSemiBold17(Strings.alert),
    //     content: LiviTextStyles.interRegular14(
    //         Strings.areYouSureYouWantToLogout,
    //         color: LiviThemes.colors.dayMaster100),
    //     actions: <CupertinoDialogAction>[
    //       CupertinoDialogAction(
    //         /// This parameter indicates this action is the default,
    //         /// and turns the action's text to bold text.
    //         isDefaultAction: true,
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //         child: LiviTextStyles.interRegular17(Strings.cancel,
    //             color: LiviThemes.colors.dayBrand100),
    //       ),
    //       CupertinoDialogAction(
    //         /// This parameter indicates the action would perform
    //         /// a destructive action such as deletion, and turns
    //         /// the action's text color to red.
    //         isDestructiveAction: true,
    //         onPressed: () {
    //           Navigator.pop(context);
    //         },
    //         child: LiviTextStyles.interRegular17(Strings.logout,
    //             color: LiviThemes.colors.error600),
    //       ),
    //     ],
    //   ),
    // );

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              Strings.thePodIsNotConnected,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            title: const Text(Strings.noConnection),
            actions: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(Strings.ok))
              ])
            ],
          );
        });
  }

  Future showDeleteMedicationAlert() async {
    void pop() {
      Navigator.pop(context);
    }

    await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: const Text(
              Strings.thisActionWillRemoveTheMedication,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            title: const Text(Strings.deleteMedication),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: LiviTextStyles.interRegular17(Strings.no,
                    color: LiviThemes.colors.dayBrand100),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () async {
                  await clearClaim();
                  pop();
                },
                child: LiviTextStyles.interRegular17(Strings.yes,
                    color: LiviThemes.colors.error600),
              ),
            ],
          );
        });
  }

  Future showUnclaimAlert() async {
    void pop() {
      Navigator.pop(context);
    }

    await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: const Text(
              Strings.thisActionWillRemoveThisLiviPod,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            title: const Text(Strings.unclaim),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: LiviTextStyles.interRegular17(Strings.no,
                    color: LiviThemes.colors.dayBrand100),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () async {
                  await reset();
                  pop();
                },
                child: LiviTextStyles.interRegular17(Strings.yes,
                    color: LiviThemes.colors.error600),
              ),
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
      await _liviPodController.removeLiviPod(liviPod);
      if (mounted) {
        setState(() {
          _nameController.clear();
          _claimed = false;
        });
      }
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
          appBar: LiviAppBar(
            title: Strings.myPod,
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
                      // Form(
                      //   key: _formKey,
                      //   child: TextFormField(
                      //     controller: _nameController,
                      //     decoration: const InputDecoration(
                      //         label: Text('Medication Name')),
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please enter a medication';
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      ElevatedButton(
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Claiming pod')),
                            );

                            await save();
                          }
                        },
                        child: const Text('Claim'),
                      ),
                    ],
                  ),
                ] else ...[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Card(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Column(
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Text(
                        //               liviPod.macAddress,
                        //               textAlign: TextAlign.center,
                        //             ),
                        //             // IconButton(
                        //             //     onPressed: () {
                        //             //       _nameController.text =
                        //             //           liviPod.medicationName;
                        //             //       if (mounted) {
                        //             //         setState(() {
                        //             //           _editName = true;
                        //             //         });
                        //             //       }
                        //             //     },
                        //             //     icon: const Icon(Icons.edit))
                        //           ],
                        //         ),
                        //         const SizedBox(
                        //           height: 20,
                        //         ),
                        //         if (liviPod.schedule == null) ...[
                        //           Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               ElevatedButton(
                        //                   onPressed: () {
                        //                     Navigator.push(context,
                        //                         MaterialPageRoute(
                        //                       builder: (context) {
                        //                         return ScheduleView(
                        //                           onAdd: (schedule) async {
                        //                             liviPod.schedule = schedule;
                        //                             await updateSchedule();
                        //                           },
                        //                           onUpdate: () async {
                        //                             await updateSchedule();
                        //                           },
                        //                         );
                        //                       },
                        //                     ));
                        //                   },
                        //                   child: const Text('Add a schedule'))
                        //             ],
                        //           ),
                        //         ] else ...[
                        //           Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Flexible(
                        //                 child: Text(
                        //                   liviPod.schedule!
                        //                       .getScheduleDescription(),
                        //                   textAlign: TextAlign.center,
                        //                   softWrap: true,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //           Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               IconButton(
                        //                   onPressed: () {
                        //                     Navigator.push(context,
                        //                         MaterialPageRoute(
                        //                       builder: (context) {
                        //                         return ScheduleView(
                        //                           schedule: liviPod.schedule,
                        //                           onAdd: (schedule) async {
                        //                             liviPod.schedule = schedule;
                        //                             await updateSchedule();
                        //                           },
                        //                           onUpdate: () async {
                        //                             await updateSchedule();
                        //                           },
                        //                         );
                        //                       },
                        //                     ));
                        //                   },
                        //                   icon: const Icon(Icons.edit)),
                        //               IconButton(
                        //                   onPressed: () async {
                        //                     liviPod.schedule = null;
                        //                     await updateSchedule();
                        //                   },
                        //                   icon: const Icon(Icons.delete))
                        //             ],
                        //           )
                        //         ]
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 120,
                                  child: LiviThemes.icons.liviPodImage),
                              LiviThemes.spacing.heightSpacer8(),
                              // if(widget.liviPod.medicationId.isNotEmpty){
                              //    StreamBuilder(stream:
                              //   MedicationService().listenToMedicationsRealTime( Provider.of<AuthController>(context,listen:false).appUser!),
                              //   builder:

                              //   ),
                              // }
                              Spacer(),
                              LiviFilledButton(
                                color: LiviThemes.colors.baseWhite,
                                text: Strings.deleteMedication,
                                borderColor: LiviThemes.colors.error300,
                                textColor: LiviThemes.colors.error600,
                                onTap: () async {
                                  await showDeleteMedicationAlert();
                                },
                              ),
                              LiviThemes.spacing.heightSpacer8(),
                              LiviFilledButton(
                                color: LiviThemes.colors.baseWhite,
                                text: Strings.unclaim,
                                borderColor: LiviThemes.colors.error300,
                                textColor: LiviThemes.colors.error600,
                                onTap: () => showUnclaimAlert(),
                              ),
                              LiviThemes.spacing.heightSpacer8(),
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     await showResetAlert();
                              //   },
                              //   child: const Text(
                              //     'Reset Pod',
                              //   ),
                              // ),
                            ],
                          ),
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
