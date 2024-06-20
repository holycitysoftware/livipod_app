import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/auth_controller.dart';
import '../../models/enums.dart';
import '../../models/medication_history.dart';
import '../../models/models.dart';
import '../../models/schedule_type.dart';
import '../../services/app_user_service.dart';
import '../../services/medication_service.dart';
import '../../themes/livi_themes.dart';
import '../../utils/string_ext.dart';
import '../../utils/strings.dart';
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
    bool availableMedications = false;
    bool dueMeds = false;
    medications.forEach(
      (element) {
        if (element.isLate()) {
          lateMedications = true;
        } else if (element.isAvailable()) {
          availableMedications = true;
        } else if (element.isDue()) {
          dueMeds = true;
        }
      },
    );
    if (lateMedications) {
      return LiviTextStyles.interRegular16(Strings.youHaveLateMedicines,
          color: LiviThemes.colors.baseBlack);
    }
    if (availableMedications) {
      return LiviTextStyles.interRegular16(Strings.youHaveAvailableMedicines,
          color: LiviThemes.colors.baseBlack);
    }
    if (dueMeds) {
      return LiviTextStyles.interRegular16(Strings.youHaveDueMedicines,
          color: LiviThemes.colors.baseBlack);
    }

    for (final element in medications) {
      if (nextMed == null) {
        nextMed = element;
      } else if (element.nextDosing != null &&
          element.nextDosing!.scheduledDosingTime != null &&
          nextMed.nextDosing != null &&
          nextMed.nextDosing!.scheduledDosingTime != null &&
          element.nextDosing!.scheduledDosingTime!
              .isBefore(nextMed.nextDosing!.scheduledDosingTime!) &&
          element.schedules.first.type != ScheduleType.asNeeded) {
        nextMed = element;
      }
    }
    if (nextMed == null) {
      return SizedBox();
    }
    if (nextMed.nextDosing!.scheduledDosingTime!.isToday()) {
      return nextMeds(
        '${Strings.nextMedsDueAt} ${DateFormat.jm().format(nextMed.nextDosing!.scheduledDosingTime!)}',
      );
    } else if (nextMed.nextDosing!.scheduledDosingTime!.isTomorrow()) {
      return nextMeds(
        '${Strings.nextMedsDueTomorrowAt} ${DateFormat.jm().format(nextMed.nextDosing!.scheduledDosingTime!)}',
      );
    } else {
      return nextMeds(
        '${Strings.nextMedsDueAt} ${DateFormat.yMMMMd('en_US').format(nextMed.nextDosing!.scheduledDosingTime!)} ${DateFormat.jm().format(nextMed.nextDosing!.scheduledDosingTime!)}',
      );
    }
  }

  Widget nextMeds(String message) {
    return LiviTextStyles.interRegular16(message,
        color: LiviThemes.colors.baseBlack);
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
    print('build home page');
    return PopScope(
      canPop: false,
      child: Scaffold(
        body:
            Consumer<AuthController>(builder: (context, authController, child) {
          return StreamBuilder<List<Medication>>(
              stream: MedicationService()
                  .listenToMedicationsRealTime(authController.appUser!),
              builder: (context, snapshot) {
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
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              if (snapshot.data != null)
                                descriptionNextMeds(snapshot.data!)
                              else
                                SizedBox(),
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                SizedBox()
                              else if (snapshot.data!.isEmpty)
                                Column(
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
                                            Strings.letsGetYouOnboarded
                                                .toUpperCase(),
                                            color: LiviThemes.colors.gray600)
                                      ],
                                    ),
                                    LiviThemes.spacing.heightSpacer4(),
                                    OnboardingCardHome(
                                      title: Strings.addYourFirstMedication,
                                      subtitle:
                                          Strings.addYourselfOrImportFromCSV,
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

                                        return OnboardingCardHome(
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
                                    OnboardingCardHome(
                                      title: Strings.addYourCaregiver,
                                      subtitle: Strings
                                          .diveIntoTheEditorAndStartCreating,
                                      icon: LiviThemes.icons.caregiverIcon(
                                        height: 24,
                                        color: LiviThemes.colors.green500,
                                      ),
                                      onTap: goToAddCaregiver,
                                    ),
                                    OnboardingCardHome(
                                      title:
                                          Strings.setYourNotificationSettings,
                                      subtitle:
                                          Strings.addYourselfOrImportFromCSV,
                                      icon: Icon(
                                        Icons.notifications,
                                        size: 24,
                                        color: LiviThemes.colors.error500,
                                      ),
                                      onTap: goToNotificationsPage,
                                    ),
                                  ],
                                ),
                              LiviThemes.spacing.heightSpacer16(),
                              cards(snapshot),
                              LiviThemes.spacing.heightSpacer12(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }

  Widget cards(AsyncSnapshot<List<Medication>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            child: CircularProgressIndicator()),
      );
    } else if (snapshot.data!.isEmpty) {
      return SizedBox();
    }

    final asNeededList = <Medication>[];
    final missedDuelist = <Medication>[];
    for (final element in snapshot.data!) {
      if (element.isAsNeeded()) {
        asNeededList.add(element);
      } else if (element.isDue() || element.isLate() || element.isAvailable()) {
        missedDuelist.add(element);
      }
    }

    return Column(
      children: [
        CardStackAnimation(
          key: Key('meds-due-cards'),
          buttons: skipConfirmButton,
          takeAllFunction: () => takeAll(missedDuelist),
          medications: missedDuelist,
          title: Strings.medsDue.toUpperCase(),
        ),
        CardStackAnimation(
          medications: asNeededList,
          key: Key('as-needed-cards'),
          // takeAllFunction: () => takeAll(asNeededList),
          buttons: confirmQuantityButton,
          title: Strings.asNeeded.toUpperCase(),
        ),
      ],
    );
  }

  Future<void> skipMedication(List<Medication> medications, int? index) async {
    if (medications.first.nextDosing != null) {
      medications.first.nextDosing!.outcome = DosingOutcome.skipped;
      medications.first.lastDosing = medications.first.nextDosing;
      await medicationService.updateMedication(medications.first);
      await medicationService.createMedicationHistory(
        MedicationHistory.createMedicationHistory(medications.first,
            Provider.of<AuthController>(context, listen: false).appUser!),
      );
    }
  }

  Future<void> takeMedication(List<Medication> medications, int? index,
      {int? quantity}) async {
    if (medications.first.nextDosing != null) {
      medications.first.nextDosing!.outcome = DosingOutcome.taken;

      final schedule = medications.first.getCurrentSchedule();
      if (medications.first.isAsNeeded() && quantity != null) {
        medications.first.nextDosing!.qtyRequested = quantity.toDouble();
        medications.first.nextDosing!.qtyDispensed = quantity.toDouble();
      } else {
        medications.first.nextDosing!.qtyRequested = schedule.scheduledDosings.;
        medications.first.nextDosing!.qtyDispensed = schedule.scheduledDosings.;
      }
      medications.first.lastDosing = medications.first.nextDosing;
      await medicationService.updateMedication(medications.first);
      await medicationService.createMedicationHistory(
        MedicationHistory.createMedicationHistory(medications.first,
            Provider.of<AuthController>(context, listen: false).appUser!),
      );
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
    _modalTextController.text =
        medication.schedules.first.prnDosing?.maxQty.toInt().toString() ?? '';
    var quantity = await LiviAlertDialog.showConfirmQuantityModal(
        context, medication, _modalTextController);
    if (quantity != null &&
        medication.schedules.first.prnDosing != null &&
        medication.nextDosing != null) {
      final maxQty = medication.schedules.first.prnDosing!.maxQty;
      final qtyRemaining = medication.nextDosing!.qtyRemaining;

      if (maxQty > qtyRemaining) {
        quantity = qtyRemaining.toInt();
      }

      await takeMedication([medication], null);
    }
  }

  Future<void> takeAll(List<Medication> medications) async {
    for (final medication in medications) {
      await takeMedication([medication], null);
    }
    setState(() {});
    return Future.value();
  }

  Widget confirmQuantityButton(List<Medication> medications, int? index) {
    index ??= 0;

    if (medications[index].nextDosing == null ||
        (medications[index].nextDosing != null &&
            medications[index].nextDosing!.qtyRemaining == null) ||
        medications[index].schedules.first.prnDosing == null) {
      return SizedBox();
    }

    final minQty = medications[index].schedules.first.prnDosing!.minQty.toInt();
    final maxQty = medications[index].schedules.first.prnDosing!.maxQty.toInt();
    final qtyRemaining = medications[index].nextDosing!.qtyRemaining.toInt();

    if (qtyRemaining == minQty || minQty == maxQty) {
      return Row(
        children: [
          Expanded(
            child: LiviOutlinedButton(
              onTap: () => takeMedication(medications, index),
              text: Strings.take,
            ),
          ),
        ],
      );
    } else if (minQty > qtyRemaining) {
      return SizedBox();
    }
    return Row(
      children: [
        Expanded(
          child: LiviOutlinedButton(
            onTap: () => showQuantityModal(medications[index!]),
            text: Strings.confirmQuantity,
          ),
        ),
      ],
    );
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
