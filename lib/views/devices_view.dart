import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../controllers/ble_controller.dart';
import '../models/livi_pod.dart';
import 'device_view.dart';

class DevicesView extends StatefulWidget {
  const DevicesView({super.key});

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  late final BleController _bleController;
  List<LiviPod> liviPodDevices = [];
  @override
  void initState() {
    _bleController = Provider.of<BleController>(context, listen: false);
    startBle();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    stopBle();
    super.dispose();
  }

  void startBle() {
    _bleController.startScan();
  }

  void stopBle() {
    _bleController.stopScan();
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

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('devices-view'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1.0) {
          _bleController.startScan();
          if (mounted) {
            setState(() {});
          }
        } else {
          _bleController.stopScan();
        }
      },
      child: Consumer<BleController>(builder: (context, controller, child) {
        liviPodDevices.clear();
        liviPodDevices.addAll(controller.liviPodDevices);
        return Padding(
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
                        itemCount: liviPodDevices.length,
                        itemBuilder: (context, index) {
                          final liviPod = liviPodDevices[index];
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
                        })
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
                    Consumer<BleController>(
                      builder: (context, deviceController, child) {
                        final List<ScanResult> scanResults = [];
                        for (final scanResult in deviceController.scanResults) {
                          if (!liviPodDevices.any((element) =>
                              element.remoteId ==
                              scanResult.device.remoteId.toString())) {
                            scanResults.add(scanResult);
                          }
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: scanResults.length,
                          itemBuilder: (context, index) {
                            final scanResult = scanResults[index];
                            return GestureDetector(
                              onTap: () {
                                final liviPod = LiviPod(
                                    remoteId:
                                        scanResult.device.remoteId.toString(),
                                    medicationName: '');
                                deviceTapped(liviPod, true);
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(scanResult.device.platformName),
                                      Text(
                                          scanResult.device.remoteId.toString(),
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
        );
      }),
    );
  }
}
