import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/enums.dart';
import '../../../models/models.dart';
import '../../../services/fda_service.dart';
import '../../../services/livi_pod_service.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/logger.dart';
import '../../../utils/string_ext.dart';
import '../../../utils/strings.dart';
import '../../views.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.myPods,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<LiviPod>>(
            stream: LiviPodService().listenToLiviPodsRealTime(
                Provider.of<AuthController>(context, listen: false).appUser!),
            builder: (context, snapshot) {
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                final livipods = snapshot.data!;
                return ListView.builder(
                  itemCount: livipods.length,
                  itemBuilder: (context, index) {
                    final livipod = livipods[index];
                    return ListTile(
                        title:
                            LiviTextStyles.interSemiBold16(livipod.macAddress),
                        subtitle:
                            LiviTextStyles.interRegular14(livipod.remoteId),
                        trailing: LiviThemes.icons.chevronRight());
                  },
                );
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: LiviTextStyles.interSemiBold36(
                              Strings.noLiviPodsAdded,
                              textAlign: TextAlign.center),
                        ),
                        LiviThemes.spacing.heightSpacer16(),
                        // LiviSearchBar(
                        //   onTap: () => goToSearchMedications(
                        //       medication: searchTextController.text),
                        //   controller: searchTextController,
                        //   onFieldSubmitted: (e) {
                        //     goToSearchMedications(medication: e);
                        //   },
                        //   focusNode: focusNode,
                        // ),
                        Spacer(
                          flex: 2,
                        ),
                      ]),
                ),
              );
            }),
      ),
    );
  }
}
