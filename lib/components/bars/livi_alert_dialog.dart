import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../services/livi_pod_service.dart';
import '../../services/medication_service.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../../utils/utils.dart';
import '../components.dart';

class LiviAlertDialog {
  void empty() {}

  static Future<LiviPod?> showModalClaimedDevice(
      BuildContext context, LiviPod? pod, Medication medication) async {
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
                            SizedBox(
                              width: 180,
                              child: LiviTextStyles.interMedium16(
                                  medication.getNameStrengthDosageForm(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    LiviThemes.spacing.heightSpacer16(),
                    Row(
                      children: [
                        Expanded(
                          child: LiviOutlinedButton(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            text: Strings.cancel,
                          ),
                        ),
                      ],
                    ),
                    LiviThemes.spacing.heightSpacer8(),
                    Row(
                      children: [
                        Expanded(
                          child: LiviOutlinedButton(
                            onTap: () async {
                              pod!.medicationId = '';
                              await LiviPodService().updateLiviPod(pod!);
                              Navigator.pop(context);
                            },
                            text: Strings.removeMedication,
                          ),
                        ),
                      ],
                    ),
                    LiviThemes.spacing.heightSpacer8(),
                    Row(
                      children: [
                        Expanded(
                          child: LiviOutlinedButton(
                            backgroundColor: LiviThemes.colors.error50,
                            textColor: LiviThemes.colors.error800,
                            borderColor: LiviThemes.colors.error300,
                            onTap: () async {
                              await LiviPodService().removeLiviPod(pod!);
                              pod = null;
                              Navigator.pop(context);
                            },
                            text: Strings.unclaim,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
    return pod;
  }

  static Future<LiviPod?> showModalClaim(
      BuildContext context, LiviPod? pod) async {
    Medication? medication;
    await showDialog(
        context: context,
        builder: (e) {
          return StatefulBuilder(
            builder: (context, setStates) => SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
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
                              LiviTextStyles.interMedium16(
                                  Strings.noMedication),
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
                          stream: MedicationService()
                              .listenToMedicationsRealTime(
                                  Provider.of<AuthController>(context)
                                      .appUser!),
                          builder: (context, snapshot) {
                            if (snapshot.data != null &&
                                snapshot.data!.isNotEmpty) {
                              medication = snapshot.data!.first;
                              return SizedBox(
                                width: double.infinity,
                                child: LiviDropdownButton<Medication>(
                                    onChanged: (e) {
                                      medication = e;
                                      setStates(() {});
                                    },
                                    isExpanded: true,
                                    value: medication,
                                    items: snapshot.data!
                                        .map<DropdownMenuItem<Medication>>(
                                      (e) {
                                        return DropdownMenuItem<Medication>(
                                          value: e,
                                          child: LiviTextStyles.interMedium16(
                                              e.name),
                                        );
                                      },
                                    ).toList()),
                              );
                            } else {
                              return SizedBox();
                            }
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
                              onTap: () async {
                                if (medication != null && pod != null) {
                                  pod!.medicationId = medication!.id;
                                }
                                await LiviPodService().updateLiviPod(pod!);
                                Navigator.pop(context);
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
            ),
          );
        });
    return pod;
  }

  // This shows a C upertinoModalPopup which hosts a CupertinoAlertDialog.
  static Future<bool> showAlertDialog(BuildContext context) async {
    var logout = false;
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
              logout = true;
              Navigator.pop(context);
            },
            child: LiviTextStyles.interRegular17(Strings.logout,
                color: LiviThemes.colors.error600),
          ),
        ],
      ),
    );
    return logout;
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

  static Future<int?> showConfirmQuantityModal(
    BuildContext context,
    Medication medication,
    TextEditingController modalTextController,
  ) async {
    return showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: LiviThemes.colors.baseWhite,
          surfaceTintColor: LiviThemes.colors.baseWhite,
          insetPadding: EdgeInsets.symmetric(horizontal: 32),
          content: Container(
            height: 330,
            width: 400,
            color: LiviThemes.colors.baseWhite,
            child: Column(
              children: [
                Spacer(),
                Row(
                  children: [
                    if (medication.dosageForm != null)
                      Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: LiviThemes.colors.brand50,
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child:
                            dosageFormIcon(dosageForm: medication.dosageForm),
                      ),
                    LiviThemes.spacing.widthSpacer8(),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: LiviTextStyles.interSemiBold16(
                                  medication.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: LiviTextStyles.interSemiBold16(
                                  medication.dosageFormStrengthType(),
                                  maxLines: 1,
                                  color: LiviThemes.colors.gray700,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                LiviInputField(
                  title: Strings.availableQuantity,
                  focusNode: FocusNode(),
                  readOnly: true,
                  controller: TextEditingController(
                      text: medication.inventoryQuantity.toString()),
                  keyboardType: TextInputType.number,
                ),
                LiviInputField(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  title: Strings.adjustQuantity,
                  focusNode: FocusNode(),
                  controller: modalTextController,
                  keyboardType: TextInputType.number,
                ),
                LiviThemes.spacing.heightSpacer16(),
                LiviDivider(),
                LiviThemes.spacing.heightSpacer16(),
                Row(
                  children: [
                    Expanded(
                      child: LiviOutlinedButton(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        text: Strings.cancel,
                      ),
                    ),
                    LiviThemes.spacing.widthSpacer8(),
                    Expanded(
                      child: LiviOutlinedButton(
                        onTap: () {
                          Navigator.of(context)
                              .pop(int.parse(modalTextController.text));
                        },
                        text: Strings.confirm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
