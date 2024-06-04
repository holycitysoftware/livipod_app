import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import '../../../services/livi_pod_service.dart';
import '../../../services/medication_service.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';

class MyPodsPage extends StatefulWidget {
  static const String routeName = '/my-pods-page';
  const MyPodsPage({
    super.key,
  });

  @override
  State<MyPodsPage> createState() => _MyPodsPageState();
}

class _MyPodsPageState extends State<MyPodsPage> {
  Medication? medication;
  bool isLoading = false;
  List<String> medications = [];
  late final BleController bleController;

  @override
  void initState() {
    bleController = Provider.of<BleController>(context, listen: false);
    startScan();
    super.initState();
  }

  Widget medicationStatus(bool connected) {
    if (connected) {
      return LiviTextStyles.interRegular14(Strings.connected,
          color: LiviThemes.colors.success600);
    }
    return LiviTextStyles.interRegular14(Strings.selectAMedication);
  }

  void startScan() {
    bleController.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.myPods,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StreamBuilder<List<LiviPod>>(
                  stream: LiviPodService().listenToLiviPodsRealTime(
                      Provider.of<AuthController>(context, listen: false)
                          .appUser!),
                  builder: (context, snapshot) {
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      final livipods = snapshot.data!;

                      return StreamBuilder<List<Medication>>(
                          stream: MedicationService()
                              .listenToMedicationsRealTime(
                                  Provider.of<AuthController>(context,
                                          listen: false)
                                      .appUser!),
                          builder: (context, medications) {
                            if (medications == null ||
                                (medications != null &&
                                    medications.data == null) ||
                                (medications != null &&
                                    medications.data != null &&
                                    medications.data!.isEmpty)) {
                              return SizedBox();
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final livipod = livipods[index];
                                final medication = medications.data!
                                    .singleWhere(
                                        (element) =>
                                            element.appUserId ==
                                            livipod.appUserId,
                                        orElse: () => Medication(name: ''));
                                return Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: LiviThemes.colors.gray200)),
                                  color: LiviThemes.colors.gray50,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        LiviThemes.icons.liviPodImageSmaller,
                                        LiviThemes.spacing.widthSpacer24(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            LiviThemes.spacing.widthSpacer8(),
                                            LiviTextStyles.interMedium16(
                                                medication
                                                    .getNameStrengthDosageForm()),
                                            medicationStatus(true),
                                          ],
                                        ),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {},
                                            icon: LiviThemes.icons
                                                .chevronRight()),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          });
                      // }
                      // return Center(
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 16),
                      //     child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Spacer(),
                      //           Padding(
                      //             padding: const EdgeInsets.symmetric(horizontal: 48),
                      //             child: LiviTextStyles.interSemiBold36(
                      //                 Strings.noLiviPodsAdded,
                      //                 textAlign: TextAlign.center),
                      //           ),
                      //           LiviThemes.spacing.heightSpacer16(),
                      //           // LiviSearchBar(
                      //           //   onTap: () => goToSearchMedications(
                      //           //       medication: searchTextController.text),
                      //           //   controller: searchTextController,
                      //           //   onFieldSubmitted: (e) {
                      //           //     goToSearchMedications(medication: e);
                      //           //   },
                      //           //   focusNode: focusNode,
                      //           // ),
                      //           Spacer(
                      //             flex: 2,
                      //           ),
                      //         ]),
                      //   ),
                      // );
                    }
                    return SizedBox();
                  }),
            ),
          ),
          LiviDivider(height: 8),
          Consumer<BleController>(builder: (context, value, child) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LiviTextStyles.interMedium14(Strings.availablePods,
                        color: LiviThemes.colors.gray500),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Card(
                        elevation: 0,
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
                                  LiviTextStyles.interMedium16(
                                      Strings.noMedication),
                                ],
                              ),
                              Spacer(),
                              LiviOutlinedButton(
                                onTap: () => claimPod(
                                    //scanResult
                                    ),
                                text: Strings.claim,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // if (value.isScanning)
                    //   loadingCardAvailablePods()
                    // else if (value.scanResults.isEmpty)
                    //   searchCardAvailablePods()
                    // else
                    //   Expanded(
                    //     child: ListView.builder(
                    //         itemCount: value.scanResults.length,
                    //         itemBuilder: (context, index) {
                    //           final item = value.scanResults[index];
                    //           return regularCardAvailablePods(item);
                    //         }),
                    //   ),
                    //TODO: BLE: remove this test
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> claimPod(
      //ScanResult scanResult,
      ) async {
    // bleController.connectToUnclaimedDevice(scanResult.device);
    final pod =
        await LiviAlertDialog.showModal(context, LiviPod(remoteId: 'test'));
  }

  Widget regularCardAvailablePods(ScanResult scanResult) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Card(
        elevation: 0,
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
                onTap: () => claimPod(
                    // scanResult
                    ),
                text: Strings.claim,
              ),
            ],
          ),
        ),
      ),
    );
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
              onTap: startScan,
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


//  CupertinoActivityIndicator(),