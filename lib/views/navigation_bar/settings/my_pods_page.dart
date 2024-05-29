import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import '../../../services/livi_pod_service.dart';
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
                    // if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                    // final livipods = snapshot.data!;
                    return ListView.builder(
                      itemCount: 2,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // final livipod = livipods[index];
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side:
                                  BorderSide(color: LiviThemes.colors.gray200)),
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
                                        'Asprin 80mg Tablet'),
                                    medicationStatus(true),
                                  ],
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () {},
                                    icon: LiviThemes.icons.chevronRight()),
                              ],
                            ),
                          ),
                        );
                      },
                    );
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
                  }),
            ),
          ),
          LiviDivider(height: 8),
          Expanded(
            child: Consumer<BleController>(builder: (context, value, child) {
              return Card(
                child: Text(' haah'),
              );
            }),
          ),
        ],
      ),
    );
  }
}
