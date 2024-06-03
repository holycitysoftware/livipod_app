import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    bleController.startScan();
    super.initState();
  }

  Widget medicationStatus(bool connected) {
    if (connected) {
      return LiviTextStyles.interRegular14(Strings.connected,
          color: LiviThemes.colors.success600);
    }
    return LiviTextStyles.interRegular14(Strings.selectAMedication);
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
                    if (value.isScanning)
                      loadingCardAvailablePods()
                    else
                      ListView.builder(
                        itemCount: value.scanResults.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final livipod = value.scanResults[index];

                          return regularCardAvailablePods(
                              LiviPod(remoteId: livipod.device.remoteId.str));
                        },
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void claimPod(LiviPod pod) {
    LiviAlertDialog.showModal(context, pod);
  }

  Widget regularCardAvailablePods(LiviPod pod) {
    return Card(
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
              onTap: () => claimPod(pod),
              text: Strings.claim,
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