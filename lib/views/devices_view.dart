import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:livipod_app/views/device_view.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../controllers/devices_controller.dart';
import '../controllers/livi_pod_controller.dart';
import '../models/livi_pod.dart';

class DevicesView extends StatefulWidget {
  const DevicesView({super.key});

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  late final DevicesController _devicesController;
  late final LiviPodController _liviPodController;
  final List<LiviPod> _liviPods = [];

  @override
  void initState() {
    _liviPodController = Provider.of<LiviPodController>(context, listen: false);
    _devicesController = Provider.of<DevicesController>(context, listen: false);
    startBle();
    super.initState();
  }

  void listenForPods() {
    _liviPodController.listenToLiviPodsRealTime().listen(handleLiviPods);
  }

  void stopListeningForPods() {
    _liviPodController
        .listenToLiviPodsRealTime()
        .listen(handleLiviPods)
        .cancel();
  }

  @override
  void dispose() {
    stopBle();
    super.dispose();
  }

  void handleLiviPods(List<LiviPod> liviPods) {
    for (final pod in liviPods) {
      final index =
          _liviPods.indexWhere((element) => element.remoteId == pod.remoteId);
      if (index == -1) {
        _liviPods.add(pod);
      } else {
        _liviPods[index] = pod;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void startBle() {
    _devicesController.startBle();
  }

  void stopBle() {
    _devicesController.stopBle();
  }

  void deviceTapped(LiviPod liviPod, bool claim) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return DeviceView(
          liviPod: liviPod,
          claim: claim,
        );
      },
    ));
  }

  void podTapped(LiviPod liviPod) {}

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('devices-view'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1.0) {
          _liviPods.clear();
          listenForPods();
          setState(() {});
        } else {
          stopListeningForPods();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text('Your Pods'),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: _liviPods.length,
                      itemBuilder: (context, index) {
                        final liviPod = _liviPods[index];
                        return GestureDetector(
                          onTap: () {
                            deviceTapped(liviPod, false);
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 20),
                              child: Text(liviPod.medicationName),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
            Flexible(
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text('Available to claim'),
                    ],
                  ),
                  Consumer<DevicesController>(
                    builder: (context, deviceController, child) {
                      List<BluetoothDevice> devices = [];
                      for (final device in deviceController.scannedDevices) {
                        if (!_liviPods.any((element) =>
                            element.remoteId == device.remoteId.toString())) {
                          devices.add(device);
                        }
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: devices.length,
                        itemBuilder: (context, index) {
                          var device = devices[index];
                          return GestureDetector(
                            onTap: () {
                              final liviPod = LiviPod(
                                  remoteId: device.remoteId.toString(),
                                  medicationName: '');
                              deviceTapped(liviPod, true);
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(device.platformName),
                                    Text(device.remoteId.toString(),
                                        style: const TextStyle(fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
