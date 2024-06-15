import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../controllers/auth_controller.dart';
import '../../models/enums.dart';
import '../../models/models.dart';
import '../../services/medication_service.dart';
import '../../themes/livi_themes.dart';
import '../../utils/string_ext.dart';
import '../../utils/strings.dart';
import '../../utils/utils.dart';

///Route: home-page
class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final now = DateTime.now();
  final medicationService = MedicationService();
  final _modalTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  PeriodOfDay getPeriodOfDayColors() {
    final periodOfDay = PeriodOfDay.getPeriodOfDayColors();
    return periodOfDay;
  }

  Widget getIcon() {
    final periodOfDay = getPeriodOfDayColors();
    switch (periodOfDay) {
      case PeriodOfDay.morning:
        return LiviThemes.icons.sunIcon(color: LiviThemes.colors.baseBlack);
      case PeriodOfDay.afternoon:
        return LiviThemes.icons
            .sunSetting1Icon(color: LiviThemes.colors.baseBlack);
      case PeriodOfDay.night:
        return LiviThemes.icons.moon1Icon(color: LiviThemes.colors.baseBlack);

      default:
        return LiviThemes.icons.sunIcon(color: LiviThemes.colors.baseBlack);
    }
  }

  Widget descriptionNextMeds(List<Medication> medications) {
    Medication? nextMed;
    if (medications.isEmpty) {
      return LiviTextStyles.interRegular16(Strings.youHaveNoMedicines,
          color: LiviThemes.colors.baseBlack);
    }
    bool lateMedications = false;
    medications.forEach(
      (element) {
        if (element.nextDosing != null &&
            element.nextDosing!.outcome == DosingOutcome.missed) {
          lateMedications = true;
        }
      },
    );
    if (lateMedications) {
      return LiviTextStyles.interRegular16(Strings.youHaveLateMedicines,
          color: LiviThemes.colors.baseBlack);
    }
    for (final element in medications) {
      if (element.nextDosing == null) {
        break;
      }
      if (nextMed == null) {
        nextMed = element;
      } else if (element.nextDosing!.scheduledDosingTime!
          .isBefore(nextMed.nextDosing!.scheduledDosingTime!)) {
        nextMed = element;
      }
    }
    if (nextMed == null) {
      return SizedBox();
    }
    if (nextMed.nextDosing!.scheduledDosingTime!.isToday()) {
      return LiviTextStyles.interRegular16(
          '${Strings.nextMedsDueAt} ${DateFormat.jm().format(nextMed.nextDosing!.scheduledDosingTime!)}',
          color: LiviThemes.colors.baseBlack);
    } else if (nextMed.nextDosing!.scheduledDosingTime!.isTomorrow()) {
      return LiviTextStyles.interRegular16(
          '${Strings.nextMedsDueTomorrowAt} ${DateFormat.jm().format(nextMed.nextDosing!.scheduledDosingTime!)}',
          color: LiviThemes.colors.baseBlack);
    } else {
      return LiviTextStyles.interRegular16(
          '${Strings.nextMedsDueAt} ${DateFormat.yMMMMd('en_US').format(nextMed.nextDosing!.scheduledDosingTime!)} ${DateFormat.jm().format(nextMed.nextDosing!.scheduledDosingTime!)}',
          color: LiviThemes.colors.baseBlack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body:
            Consumer<AuthController>(builder: (context, authController, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: getPeriodOfDayColors().colors,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // shrinkWrap: true,
                  // padding: const EdgeInsets.all(24.0),
                  children: [
                    LiviThemes.spacing.heightSpacer24(),
                    LiviTextStyles.interMedium12(
                        '${DateFormat('EEEE').format(now)}, ${now.day} ${DateFormat('MMMM').format(now)}'
                            .toUpperCase(),
                        color: LiviThemes.colors.gray600),
                    Row(
                      children: [
                        getIcon(),
                        LiviThemes.spacing.widthSpacer8(),
                        LiviTextStyles.interSemiBold24(
                          '${getPeriodOfDayColors().description}, ${authController.appUser!.name.getFirstWord()}',
                        )
                      ],
                    ),
                    StreamBuilder<List<Medication>>(
                      stream: MedicationService()
                          .listenToMedicationsRealTime(authController.appUser!),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return SizedBox();
                        }
                        return descriptionNextMeds(snapshot.data!);
                      },
                    ),
                    LiviThemes.spacing.heightSpacer16(),
                    StreamBuilder<List<Medication>>(
                        stream: MedicationService().listenToMedicationsRealTime(
                            authController.appUser!),
                        builder: (context, snapshot) {
                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return SizedBox();
                          }
                          final list = snapshot.data!.where((element) {
                            return element.nextDosing != null &&
                                (element.nextDosing!.outcome ==
                                        DosingOutcome.missed ||
                                    element.isDue());
                          }).toList();
                          return CardStackAnimation(
                            key: Key('meds-due-cards'),
                            buttons: skipConfirmButton,
                            // medications: snapshot.data !,
                            medications: list,
                            title: Strings.medsDue.toUpperCase(),
                          );
                        }),
                    LiviThemes.spacing.heightSpacer12(),
                    StreamBuilder<List<Medication>>(
                        stream: MedicationService().listenToMedicationsRealTime(
                            authController.appUser!),
                        builder: (context, snapshot) {
                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return SizedBox();
                          }
                          final list = snapshot.data!.where((element) {
                            return element.isAsNeeded();
                          }).toList();
                          return CardStackAnimation(
                            medications: list,
                            key: Key('as-needed-cards'),
                            buttons: confirmQuantityButton,
                            // medications: snapshot.data!,
                            title: Strings.asNeeded.toUpperCase(),
                          );
                        }),
                    // LiviThemes.spacing.heightSpacer12(),
                    // StreamBuilder<List<Medication>>(
                    //     stream: MedicationService().listenToMedicationsRealTime(
                    //         authController.appUser!),
                    //     builder: (context, snapshot) {
                    //       if (snapshot.data == null || snapshot.data!.isEmpty) {
                    //         return SizedBox();
                    //       }
                    //       final list = snapshot.data!.where((element) {
                    //         return element.nextDosing != null &&
                    //             element.nextDosing!.outcome !=
                    //                 DosingOutcome.missed &&
                    //             !element.isDue();
                    //       }).toList();
                    //       return CardStackAnimation(
                    //         medications: list,
                    //         key: Key('as-needed-cards'),
                    //         buttons: confirmQuantityButton(),
                    //         // medications: snapshot.data!,
                    //         title: Strings.asNeeded.toUpperCase(),
                    //       );
                    //     }),
                    LiviThemes.spacing.heightSpacer16(),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> skipMedication(List<Medication> medications, int? index) async {
    if (medications.first.nextDosing != null) {
      medications.first.nextDosing!.outcome = DosingOutcome.skipped;
      await medicationService.updateMedication(medications.first);
    }
    setState(() {});
  }

  Future<void> takeMedication(List<Medication> medications, int? index) async {
    if (medications.first.nextDosing != null) {
      medications.first.nextDosing!.outcome = DosingOutcome.taken;
      await medicationService.updateMedication(medications.first);
    }
    setState(() {});
  }

  Widget skipConfirmButton(List<Medication> medications, int? index) {
    return Row(
      children: [
        Expanded(
          child: LiviOutlinedButton(
            onTap: () => skipMedication(medications, index),
            text: Strings.skip,
          ),
        ),
        LiviThemes.spacing.widthSpacer8(),
        Expanded(
          child: LiviOutlinedButton(
            onTap: () => takeMedication(medications, index),
            text: Strings.confirm,
          ),
        )
      ],
    );
  }

  Future<void> showQuantityModal(Medication medication) async {
    final quantity = await showDialog<int>(
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
                      child: Row(
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
                  controller: _modalTextController,
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
                          Navigator.of(context).pop(_modalTextController.text);
                        },
                        text: Strings.confirm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // actions: <Widget>[
          //   TextButton(
          //     style: TextButton.styleFrom(
          //       textStyle: Theme.of(context).textTheme.labelLarge,
          //     ),
          //     child: const Text(Strings.cancel),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          //   TextButton(
          //     style: TextButton.styleFrom(
          //       textStyle: Theme.of(context).textTheme.labelLarge,
          //     ),
          //     child: const Text(Strings.confirm),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        ),
      ),
    );
  }

  Future<void> takeAll(List<Medication> medications) async {
    for (final medication in medications) {
      await takeMedication([medication], null);
    }
    setState(() {});
    return Future.value();
  }

  Widget confirmQuantityButton(List<Medication> medications, int? index) {
    return Row(
      children: [
        Expanded(
          child: LiviOutlinedButton(
            onTap: () => showQuantityModal(medications.first),
            text: Strings.confirmQuantity,
          ),
        ),
      ],
    );
  }
}
