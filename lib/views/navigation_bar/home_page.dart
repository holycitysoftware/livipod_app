import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../controllers/auth_controller.dart';
import '../../models/enums.dart';
import '../../models/medication_history.dart';
import '../../models/models.dart';
import '../../services/app_user_service.dart';
import '../../services/medication_service.dart';
import '../../themes/livi_themes.dart';
import '../../utils/string_ext.dart';
import '../../utils/strings.dart';
import '../../utils/utils.dart';
import '../views.dart';

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

  void goToSearchMedications({String? medication}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchMedicationPage(
          medication: medication,
        ),
      ),
    );
    setState(() {});
  }

  Future<void> goToAddCaregiver() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCaregiverPage(),
      ),
    );
    setState(() {});
  }

  Future<void> goToNotificationsPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsPage(),
      ),
    );
    setState(() {});
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
                        if (snapshot.data != null) {
                          return descriptionNextMeds(snapshot.data!);
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    StreamBuilder<List<Medication>>(
                      stream: MedicationService()
                          .listenToMedicationsRealTime(authController.appUser!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox();
                        }
                        if (snapshot.data == null ||
                            (snapshot.data != null && snapshot.data!.isEmpty)) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LiviThemes.spacing.heightSpacer16(),
                              Row(
                                children: [
                                  LiviThemes.icons.rocket2Icon(
                                      color: LiviThemes.colors.gray600,
                                      height: 16),
                                  LiviThemes.spacing.widthSpacer8(),
                                  LiviTextStyles.interMedium12(
                                      Strings.letsGetYouOnboarded.toUpperCase(),
                                      color: LiviThemes.colors.gray600)
                                ],
                              ),
                              LiviThemes.spacing.heightSpacer4(),
                              onboardingCard(
                                title: Strings.addYourFirstMedication,
                                subtitle: Strings.addYourselfOrImportFromCSV,
                                icon: LiviThemes.icons.alarmAddIcon(
                                  height: 24,
                                  color: LiviThemes.colors.brand600,
                                ),
                                onTap: goToSearchMedications,
                              ),
                              StreamBuilder<List<AppUser>>(
                                stream: AppUserService()
                                    .listenToCaregiversRealTime(
                                        authController.appUser!),
                                builder: (context, snapshot) {
                                  if (snapshot.data == null ||
                                      (snapshot.data != null &&
                                          snapshot.data!.isEmpty)) {
                                    return SizedBox();
                                  }
                                  final user = snapshot.data!;

                                  return onboardingCard(
                                    title: Strings.addYourCaregiver,
                                    subtitle: Strings
                                        .diveIntoTheEditorAndStartCreating,
                                    icon: LiviThemes.icons.caregiverIcon(
                                      height: 24,
                                      color: LiviThemes.colors.green500,
                                    ),
                                    onTap: goToAddCaregiver,
                                  );
                                },
                              ),
                              onboardingCard(
                                title: Strings.addYourCaregiver,
                                subtitle:
                                    Strings.diveIntoTheEditorAndStartCreating,
                                icon: LiviThemes.icons.caregiverIcon(
                                  height: 24,
                                  color: LiviThemes.colors.green500,
                                ),
                                onTap: goToAddCaregiver,
                              ),
                              onboardingCard(
                                title: Strings.setYourNotificationSettings,
                                subtitle: Strings.addYourselfOrImportFromCSV,
                                icon: Icon(
                                  Icons.notifications,
                                  size: 24,
                                  color: LiviThemes.colors.error500,
                                ),
                                onTap: goToNotificationsPage,
                              ),
                            ],
                          );
                        }
                        return SizedBox();
                      },
                    ),
                    LiviThemes.spacing.heightSpacer16(),
                    StreamBuilder<List<Medication>>(
                        stream: MedicationService().listenToMedicationsRealTime(
                            authController.appUser!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          3),
                                  child: CircularProgressIndicator()),
                            );
                          } else if (snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return SizedBox();
                          }
                          final asNeededList = snapshot.data!.where((element) {
                            return element.isAsNeeded();
                          }).toList();
                          final missedDuelist = snapshot.data!.where((element) {
                            return element.nextDosing != null &&
                                (element.nextDosing!.outcome ==
                                        DosingOutcome.missed ||
                                    element.isDue());
                          }).toList();
                          final othersList = snapshot.data!.where((element) {
                            return !asNeededList.contains(element) &&
                                !missedDuelist.contains(element);
                          }).toList();
                          othersList.sort((a, b) {
                            if (a.nextDosing == null || b.nextDosing == null) {
                              return 0;
                            }
                            return a.nextDosing!.scheduledDosingTime!
                                .compareTo(b.nextDosing!.scheduledDosingTime!);
                          });

                          return Column(
                            children: [
                              CardStackAnimation(
                                medications: asNeededList,
                                key: Key('as-needed-cards'),
                                buttons: confirmQuantityButton,
                                // medications: snapshot.data!,
                                title: Strings.asNeeded.toUpperCase(),
                              ),
                              CardStackAnimation(
                                key: Key('meds-due-cards'),
                                buttons: skipConfirmButton,
                                // medications: snapshot.data !,
                                medications: missedDuelist,
                                title: Strings.medsDue.toUpperCase(),
                              ),
                              ...otherCards(othersList),
                            ],
                          );
                        }),
                    LiviThemes.spacing.heightSpacer12(),
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
      medications.first.lastDosing = medications.first.nextDosing;
      await medicationService.updateMedication(medications.first);
      await medicationService.createMedicationHistory(
          MedicationHistory.createMedicationHistory(medications.first,
              Provider.of<AuthController>(context, listen: false).appUser!));
    }
  }

  Future<void> takeMedication(List<Medication> medications, int? index) async {
    if (medications.first.nextDosing != null) {
      medications.first.nextDosing!.outcome = DosingOutcome.taken;
      medications.first.lastDosing = medications.first.nextDosing;
      await medicationService.updateMedication(medications.first);
      await medicationService.createMedicationHistory(
          MedicationHistory.createMedicationHistory(medications.first,
              Provider.of<AuthController>(context, listen: false).appUser!));
    }
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
                          Navigator.of(context)
                              .pop(int.parse(_modalTextController.text));
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
    if (quantity != null &&
        medication.schedules.first.prnDosing != null &&
        medication.schedules.first.prnDosing!.maxQty != quantity) {
      medication.schedules.first.prnDosing!.maxQty = quantity.toDouble();
      medication.schedules.first.prnDosing!.minQty = quantity.toDouble();
      await medicationService.updateMedication(medication);
    }
  }

  Future<void> takeAll(List<Medication> medications) async {
    for (final medication in medications) {
      await takeMedication([medication], null);
    }
    setState(() {});
    return Future.value();
  }

  Widget onboardingCard({
    required String title,
    required String subtitle,
    required Widget icon,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: .5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: LiviThemes.colors.gray200,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: icon,
                ),
              ),
              LiviThemes.spacing.widthSpacer12(),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: LiviTextStyles.interSemiBold14(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: LiviTextStyles.interRegular14(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                    ]),
              ),
              LiviThemes.icons.chevronRight(),
            ],
          ),
        ),
      ),
    );
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

  List<Widget> otherCards(List<Medication> medications) {
    final list = <Widget>[];
    for (var i = 0; i < medications.length; i++) {
      final similarItems = medications
          .where((element) =>
              element.nextDosing != null &&
              medications[i].nextDosing != null &&
              element.nextDosing!.scheduledDosingTime ==
                  medications[i].nextDosing!.scheduledDosingTime)
          .toList();
      if (similarItems.isNotEmpty) {
        list.add(
          Column(
            children: [
              CardStackAnimation(
                key: Key('other-cards-$i'),
                buttons: skipConfirmButton,
                // medications: snapshot.data !,
                medications: similarItems,
                title: getTimeDescription(
                    similarItems.first.nextDosing!.scheduledDosingTime!),
              ),
            ],
          ),
        );
      }
      i += similarItems.length - 1;
    }
    return list;
  }

  String getTimeDescription(DateTime scheduledDosingTime) {
    if (scheduledDosingTime.isToday()) {
      return DateFormat.jm().format(scheduledDosingTime);
    } else if (scheduledDosingTime.isTomorrow()) {
      return '${Strings.tomorrow} ${DateFormat.jm().format(scheduledDosingTime)}';
    } else {
      return '${DateFormat.MMMMd('en_US').format(scheduledDosingTime)} ${DateFormat.jm().format(scheduledDosingTime)}';
    }
  }
}
