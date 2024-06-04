import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../services/medication_service.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class LiviAlertDialog {
  void empty() {}

  static Future<LiviPod?> showModal(BuildContext context, LiviPod? pod) async {
    Medication? medication;
    await showDialog(
        context: context,
        builder: (e) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                      ],
                    ),
                    LiviThemes.spacing.heightSpacer16(),
                    LiviTextStyles.interMedium14(Strings.selectAMedication,
                        color: LiviThemes.colors.gray500),
                    LiviThemes.spacing.heightSpacer8(),
                    StreamBuilder<List<Medication>>(
                        stream: MedicationService().listenToMedicationsRealTime(
                            Provider.of<AuthController>(context).appUser!),
                        builder: (context, snapshot) {
                          return SizedBox(
                            width: double.infinity,
                            child: LiviDropdownButton<Medication?>(
                                onChanged: (e) {
                                  medication = e;
                                },
                                isExpanded: true,
                                value: medication,
                                items: snapshot.data != null &&
                                        snapshot.data!.isNotEmpty
                                    ? snapshot.data!
                                        .map(
                                          (e) => DropdownMenuItem<Medication>(
                                            child: LiviTextStyles.interMedium16(
                                                e.name),
                                          ),
                                        )
                                        .toList()
                                    : [
                                        DropdownMenuItem(
                                          child: LiviTextStyles.interMedium16(
                                              Strings.noMedsAvailable),
                                        )
                                      ]),
                          );
                        }),
                    LiviThemes.spacing.heightSpacer8(),
                    Row(
                      children: [
                        Expanded(
                          child: LiviOutlinedButton(
                            onTap: () {
                              Navigator.pop(context);
                              pod = null;
                            },
                            text: Strings.cancel,
                          ),
                        ),
                        LiviThemes.spacing.widthSpacer8(),
                        Expanded(
                          child: LiviOutlinedButton(
                            onTap: () {
                              if (medication != null && pod != null) {
                                pod!.medicationId = medication!.id;
                              }
                            },
                            backgroundColor: LiviThemes.colors.brand600,
                            text: Strings.claim,
                            textColor: LiviThemes.colors.baseWhite,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        });
    return pod;
  }

  // This shows a C upertinoModalPopup which hosts a CupertinoAlertDialog.
  static Future<void> showAlertDialog(BuildContext context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: LiviTextStyles.interSemiBold17(Strings.alert),
        content: LiviTextStyles.interRegular14(
            Strings.areYouSureYouWantToLogout,
            color: LiviThemes.colors.dayMaster100),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: LiviTextStyles.interRegular17(Strings.cancel,
                color: LiviThemes.colors.dayBrand100),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: LiviTextStyles.interRegular17(Strings.logout,
                color: LiviThemes.colors.error600),
          ),
        ],
      ),
    );
  }

  static Future<bool> removeCaregiver(BuildContext context, String name) async {
    var remove = false;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: LiviTextStyles.interSemiBold17(Strings.removeCaregiver),
        content: LiviTextStyles.interRegular14(
            '${Strings.areYouSureYouWantToRemove} $name ${Strings.willNoLongerHaveAccess}',
            color: LiviThemes.colors.dayMaster100),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            onPressed: () {
              Navigator.pop(context);
            },
            child: LiviTextStyles.interRegular17(Strings.cancel,
                color: LiviThemes.colors.dayBrand100),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              remove = true;
            },
            child: LiviTextStyles.interRegular17(Strings.remove,
                color: LiviThemes.colors.error600),
          ),
        ],
      ),
    );
    return remove;
  }
}
