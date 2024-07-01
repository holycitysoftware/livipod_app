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
  late final StreamSubscription<List<Medication>> _stream;
  List<Medication>? medicationsList = null;
  bool isFirstLogin = false;
  Timer? timerCards;

  final asNeededList = <Medication>[];
  final missedDuelist = <Medication>[];

  @override
  void initState() {
    final authenticatedUser =
        Provider.of<AuthController>(context, listen: false).appUser!;
    _stream = MedicationService()
        .listenToMedicationsRealTime(authenticatedUser)
        .listen(listenToMedications);
    // refreshData();
    super.initState();
  }

  void refreshData() {
    timerCards ??= Timer.periodic(const Duration(seconds: 20), (timer) async {
      final localAsNeededList = asNeededList;
      final localMissedDuelist = missedDuelist;

      await getDueMedications();

      var isAsNeededDifferent = true;
      for (final e in localAsNeededList) {
        for (final a in asNeededList) {
          if (e.id == a.id) {
            isAsNeededDifferent = false;
            break;
          } else if (asNeededList.last == a) {
            isAsNeededDifferent = true;
            print(a.name);
            print('HERE');
          }
        }
        if (isAsNeededDifferent) {
          if (mounted) {
            print(' oh im setting the state');
            setState(() {});
          }
        }
      }

      var isMissedDifferent = true;
      for (final e in localMissedDuelist) {
        for (final a in missedDuelist) {
          if (e.id == a.id) {
            isMissedDifferent = false;
            break;
          } else if (missedDuelist.last == a) {
            isMissedDifferent = true;
            print(a.name);
            print('HERE');
          }
        }

        if (isMissedDifferent) {
          if (mounted) {
            print(' oh im setting the state');
            setState(() {});
          }
        }
      }
      timerCards!.cancel();
      timerCards = null;
      refreshData();
    });
  }

  StreamSubscription<List<Medication>> listenToMedications(
      List<Medication> list) {
    if (mounted) {
      setState(() {
        medicationsList = list;
      });
    }
    return _stream;
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
    }
  }

  Widget descriptionNextMeds() {
    Medication? nextMed;
    if (medicationsList == null) {
      return SizedBox();
    }
    if (medicationsList!.isEmpty) {
      return LiviTextStyles.interRegular16(Strings.youHaveNoMedicines,
          color: LiviThemes.colors.baseBlack);
    }
    bool lateMedications = false;
    bool availableMedications = false;
    bool dueMeds = false;
    for (final element in medicationsList!) {
      if (element.isLate()) {
        lateMedications = true;
      } else if (element.isAvailable()) {
        availableMedications = true;
      } else if (element.isDue()) {
        dueMeds = true;
      }
    }
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

    for (final element in medicationsList!) {
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
    if (nextMed == null ||
        (nextMed != null && nextMed.nextDosing == null) ||
        (nextMed.isAsNeeded())) {
      return nextMeds(
        'There is nothing due',
      );
    }
    // for UI convert to local time
    final localTime = nextMed.nextDosing!.scheduledDosingTime!.toLocal();
    if (localTime.isToday()) {
      return nextMeds(
        '${Strings.nextMedsDueAt} ${DateFormat.jm().format(localTime)}',
      );
    } else if (localTime.isTomorrow()) {
      return nextMeds(
        '${Strings.nextMedsDueTomorrowAt} ${DateFormat.jm().format(localTime)}',
      );
    } else {
      return nextMeds(
        '${Strings.nextMedsDueAt} ${DateFormat.yMMMMd('en_US').format(localTime)} ${DateFormat.jm().format(localTime)}',
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
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> goToAddCaregiver() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCaregiverPage(),
      ),
    );
    if (mounted) {
      setState(() {});
    }
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body:
            Consumer<AuthController>(builder: (context, authController, child) {
          if (authController.appUser == null) {
            return SizedBox();
          }
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
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).viewPadding.top,
                    ),
                  ),
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
                        if (medicationsList != null &&
                            medicationsList!.isNotEmpty)
                          descriptionNextMeds()
                        else
                          SizedBox(),
                        if (medicationsList == null)
                          SizedBox()
                        else if (medicationsList!.isEmpty)
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
                                      Strings.letsGetYouOnboarded.toUpperCase(),
                                      color: LiviThemes.colors.gray600)
                                ],
                              ),
                              LiviThemes.spacing.heightSpacer4(),
                              OnboardingCardHome(
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
                                subtitle:
                                    Strings.diveIntoTheEditorAndStartCreating,
                                icon: LiviThemes.icons.caregiverIcon(
                                  height: 24,
                                  color: LiviThemes.colors.green500,
                                ),
                                onTap: goToAddCaregiver,
                              ),
                              OnboardingCardHome(
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
                          ),
                        LiviThemes.spacing.heightSpacer16(),
                        cards(),
                        LiviThemes.spacing.heightSpacer12(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> getDueMedications() async {
    asNeededList.clear();
    missedDuelist.clear();
    // final list = await MedicationService().getUserMedications(
    //     Provider.of<AuthController>(context, listen: false).appUser!);
    for (final element in medicationsList!) {
      if (element.nextDosing != null &&
          element.isAsNeeded() &&
          element.nextDosing!.scheduledDosingTime!.millisecondsSinceEpoch <
              DateTime.now().millisecondsSinceEpoch) {
        asNeededList.add(element);
      } else if (element.isDue() || element.isLate() || element.isAvailable()) {
        missedDuelist.add(element);
      }
    }
  }

  Widget cards() {
    if (medicationsList == null) {
      return Center(
        child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            child: CircularProgressIndicator()),
      );
    } else if (medicationsList == null ||
        (medicationsList != null && medicationsList!.isEmpty)) {
      return SizedBox();
    }
    getDueMedications();
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

  Future<void> takeMedication(
    List<Medication> medications,
    int? index, {
    int takenQuantity = 1,
    DosingOutcome outcome = DosingOutcome.taken,
  }) async {
    var qtySkipped = 0;

    if (medications[index ?? 0].nextDosing != null) {
      const qtyMissed = 0;
      final medication = medications[index ?? 0];
      final nextDosing = medication.nextDosing!;
      final lastDosing = Dosing();

      if (medicationsList != null) {
        medicationsList!.remove(medication);
        setState(() {});
      }

      nextDosing.qtyRemaining -= qtyMissed + qtySkipped + takenQuantity;
      lastDosing.dosingId = nextDosing.dosingId;
      lastDosing.qtyMissed = 0;
      lastDosing.qtySkipped = 0;
      lastDosing.qtyRemaining = nextDosing.qtyRemaining;
      lastDosing.scheduledDosingTime = nextDosing.scheduledDosingTime;
      lastDosing.lastDosingTime = DateTime.now().toUtc();
      lastDosing.outcome = outcome;

      if (medication.isAsNeeded() && takenQuantity != null) {
        nextDosing.qtyRemainingForDay -= takenQuantity;
        lastDosing.qtyRequested = takenQuantity.toDouble();
        lastDosing.qtyDispensed = takenQuantity.toDouble();
      } else {
        final schedule = medications.first.getCurrentSchedule();
        final currentScheduleDosing = schedule.getCurrentScheduleDosing();
        lastDosing.qtyRequested = currentScheduleDosing.qty;
        lastDosing.qtyDispensed = currentScheduleDosing.qty;
        if (outcome == DosingOutcome.skipped) {
          qtySkipped = takenQuantity;
        }
      }

      // update inventory if not using a POD
      medication.inventoryQuantity -= lastDosing.qtyDispensed.toInt();
      if (medication.inventoryQuantity < 0) {
        medication.inventoryQuantity = 0;
      }

      medication.nextDosing = nextDosing;
      medication.lastDosing = lastDosing;

      await medicationService.updateMedication(medication);
      await medicationService.createMedicationHistory(
        MedicationHistory.createMedicationHistory(medication,
            Provider.of<AuthController>(context, listen: false).appUser!),
      );
    }
  }

  Widget skipConfirmButton(List<Medication> medications, int? index) {
    return Row(
      children: [
        Expanded(
          child: LiviOutlinedButton(
            onTap: () => takeMedication(medications, index,
                outcome: DosingOutcome.skipped),
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

      await takeMedication([medication], null, takenQuantity: quantity);
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
      final qty =
          medications.first.getCurrentSchedule().prnDosing!.maxQty.toInt();
      return Row(
        children: [
          Expanded(
            child: LiviOutlinedButton(
              onTap: () =>
                  takeMedication(medications, index, takenQuantity: qty),
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
            onTap: () => showQuantityModal(
              medications[index!],
            ),
            text: Strings.confirmQuantity,
          ),
        ),
      ],
    );
  }

  // String getTimeDescription(DateTime scheduledDosingTime) {
  //   if (scheduledDosingTime.isToday()) {
  //     return DateFormat.jm().format(scheduledDosingTime);
  //   } else if (scheduledDosingTime.isTomorrow()) {
  //     return '${Strings.tomorrow} ${DateFormat.jm().format(scheduledDosingTime)}';
  //   } else {
  //     return '${DateFormat.MMMMd('en_US').format(scheduledDosingTime)} ${DateFormat.jm().format(scheduledDosingTime)}';
  //   }
  // }
}
