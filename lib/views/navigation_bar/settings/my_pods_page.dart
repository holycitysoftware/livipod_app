import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import '../../../services/livi_pod_service.dart';
import '../../../services/medication_service.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';
import '../../views.dart';

class MyPodsPage extends StatefulWidget {
  const MyPodsPage({super.key});

  @override
  State<MyPodsPage> createState() => _MyPodsPageState();
}

class _MyPodsPageState extends State<MyPodsPage> {
  late final BleController _bleController;
  List<LiviPod> liviPodDevices = [];
  List<Medication> medicationsList = [];
  late StreamSubscription<List<LiviPod>> liviPodsStreamSubscription;
  @override
  void initState() {
    _bleController = Provider.of<BleController>(context, listen: false);
    startBle();
    liviPodsStreamSubscription = _bleController.listenForLiviPodsRealTime(
        Provider.of<AuthController>(context, listen: false).appUser!);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    stopBle();
    liviPodsStreamSubscription.cancel();
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
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.myPods,
      ),
      body: VisibilityDetector(
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
        child: StreamBuilder<List<Medication>>(
            stream: MedicationService().listenToMedicationsRealTime(
                Provider.of<AuthController>(context, listen: false).appUser!),
            builder: (context, medications) {
              return Consumer<BleController>(
                  builder: (context, controller, child) {
                liviPodDevices.clear();
                liviPodDevices.addAll(controller.liviPodDevices);
                if (medications.data != null) {
                  medications.data!.forEach((medication) {
                    if (medication.id != null) {
                      final liviPod = liviPodDevices.firstWhere(
                        (element) => element.medicationId == medication.id,
                        orElse: () => LiviPod(remoteId: ''),
                      );
                      if (liviPod != null && liviPod.remoteId.isNotEmpty) {
                        medicationsList.add(medication);
                      }
                    }
                  });
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: StreamBuilder<List<LiviPod>>(
                          stream: _bleController.liviPodController
                              .listenToLiviPodsRealTime(
                                  Provider.of<AuthController>(context,
                                          listen: false)
                                      .appUser!),
                          builder: (context, snapshot) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (snapshot.data != null &&
                                      snapshot.data!.isNotEmpty)
                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (ctx, index) {
                                          final liviPod = snapshot.data![index];
                                          return GestureDetector(
                                            onTap: () {
                                              deviceTapped(liviPod, false);
                                            },
                                            child: Card(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  side: BorderSide(
                                                      color: LiviThemes
                                                          .colors.gray200)),
                                              color: LiviThemes.colors.gray50,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Row(
                                                  children: [
                                                    LiviThemes.icons
                                                        .liviPodImageSmaller,
                                                    LiviThemes.spacing
                                                        .widthSpacer24(),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          LiviThemes.spacing
                                                              .widthSpacer8(),
                                                          if (liviPod
                                                              .medicationId
                                                              .isEmpty)
                                                            LiviTextStyles
                                                                .interMedium16(
                                                                    Strings
                                                                        .noMedication)
                                                          else if (medicationsList
                                                              .isNotEmpty)
                                                            LiviTextStyles.interMedium16(
                                                                medicationsList[
                                                                        index]
                                                                    .getNameStrengthDosageForm(),
                                                                maxLines: 1),
                                                          medicationStatus(
                                                              controller
                                                                  .isConnected(
                                                                      liviPod
                                                                          .remoteId)),
                                                        ],
                                                      ),
                                                    ),
                                                    LiviThemes.icons
                                                        .chevronRight()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                  else
                                    LiviTextStyles.interMedium14(
                                      Strings.youHaveNoPods,
                                      color: LiviThemes.colors.gray500,
                                    )
                                ],
                              ),
                            );
                          }),
                    ),
                    LiviDivider(height: 8),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LiviTextStyles.interMedium14(Strings.availablePods,
                                color: LiviThemes.colors.gray500),
                            Consumer<BleController>(
                              builder: (context, deviceController, child) {
                                final List<ScanResult> scanResults = [];
                                for (final scanResult
                                    in deviceController.scanResults) {
                                  if (!liviPodDevices.any((element) =>
                                      element.remoteId ==
                                      scanResult.device.remoteId.toString())) {
                                    scanResults.add(scanResult);
                                  }
                                }
                                if (deviceController.isScanning) {
                                  return loadingCardAvailablePods();
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: scanResults.length,
                                  itemBuilder: (context, index) {
                                    final scanResult = scanResults[index];
                                    return regularCardAvailablePods(
                                      scanResult,
                                      // ScanResult(
                                      //     rssi: 0,
                                      //     timeStamp: DateTime.now(),
                                      //     device: BluetoothDevice(
                                      //       remoteId: DeviceIdentifier('jaja'),
                                      //     ),
                                      //     advertisementData: AdvertisementData(
                                      //         advName: '',
                                      //         txPowerLevel: 0,
                                      //         appearance: 0,
                                      //         connectable: true,
                                      //         manufacturerData: {},
                                      //         serviceData: {},
                                      //         serviceUuids: []),
                                      //         ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              });
            }),
      ),
    );
  }

  Widget medicationStatus(bool connected) {
    if (connected) {
      return LiviTextStyles.interRegular14(Strings.connected,
          color: LiviThemes.colors.success600);
    }
    return LiviTextStyles.interRegular14(Strings.notConnected);
  }

  Widget regularCardAvailablePods(ScanResult scanResult) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: LiviThemes.colors.gray200),
        ),
        color: LiviThemes.colors.gray50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              LiviThemes.icons.liviPodImageSmaller,
              LiviThemes.spacing.widthSpacer24(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LiviThemes.spacing.widthSpacer8(),
                  LiviTextStyles.interMedium16(Strings.noMedication),
                ],
              ),
              Spacer(),
              LiviOutlinedButton(
                // onTap: () {
                //   final liviPod = LiviPod(
                //     remoteId: scanResult.device.remoteId.toString(),
                //   );
                //   deviceTapped(liviPod, true);
                // },

                onTap: () {
                  final liviPod = LiviPod(
                    remoteId: scanResult.device.remoteId.toString(),
                  );
                  deviceTapped(liviPod, true);
                },
                text: Strings.claim,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> claimPod(
    ScanResult scanResult,
  ) async {
    final pod = await LiviAlertDialog.showModalClaim(
        context, LiviPod(remoteId: 'test'));

    if (pod != null) {
      pod.appUserId =
          Provider.of<AuthController>(context, listen: false).appUser!.id;
      await LiviPodService().addLiviPod(pod);
      _bleController.connectToUnclaimedDevice(scanResult.device);
    }
    setState(() {});
  }

  Widget searchCardAvailablePods() {
    return Card(
      elevation: 0,
      color: LiviThemes.colors.gray50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            LiviTextStyles.interRegular14(
              Strings.noDevicesFound,
              color: LiviThemes.colors.gray400,
            ),
            Spacer(),
            LiviOutlinedButton(
              onTap: startBle,
              backgroundColor: LiviThemes.colors.brand600,
              text: Strings.search,
              textColor: LiviThemes.colors.baseWhite,
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingCardAvailablePods() {
    return Card(
      elevation: 0,
      color: LiviThemes.colors.gray50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Opacity(
              opacity: 0,
              child: CupertinoActivityIndicator(),
            ),
            Spacer(),
            LiviTextStyles.interRegular14(
              Strings.searching,
              color: LiviThemes.colors.gray400,
            ),
            Spacer(),
            CupertinoActivityIndicator(
              color: LiviThemes.colors.gray400,
            ),
          ],
        ),
      ),
    );
  }
}
