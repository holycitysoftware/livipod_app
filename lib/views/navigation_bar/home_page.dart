import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
  final List<Medication> medicationsList = [];
  final asNeededList = <Medication>[];
  final missedDuelist = <Medication>[];
  final othersList = <Medication>[];
  late final StreamSubscription medicationsStreamSubscription;

  @override
  void initState() {
    setupMedicationListener();
    super.initState();
  }

  void setupMedicationListener() {
    final authenticatedUser =
        Provider.of<AuthController>(context, listen: false).appUser!;
    medicationsStreamSubscription = medicationService
        .listenToMedicationsRealTime(authenticatedUser)
        .listen(listenToMedications);
  }

  void listenToMedications(List<Medication> list) {
    medicationsList.clear();
    medicationsList.addAll(list);
    setState(() {});
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
              .isBefore(nextMed.nextDosing!.scheduledDosingTime!) &&
          //TODO: Check this with bill
          element.schedules.first.type != ScheduleType.asNeeded) {
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
  void dispose() {
    medicationsStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build home page');
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
                        if (medicationsList != null)
                          descriptionNextMeds(medicationsList)
                        else
                          SizedBox(),
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting)
                        //   SizedBox()
                        // else
                        if (medicationsList.isEmpty)
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
                        cards(medicationsList),
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

  Widget cards(List<Medication> medications) {
    // if (snapshot.connectionState == ConnectionState.waiting) {
    //   return Center(
    //     child: Padding(
    //         padding:
    //             EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
    //         child: CircularProgressIndicator()),
    //   );
    // } else
    if (medications.isEmpty) {
      return SizedBox();
    }

    final asNeededList = <Medication>[];
    final missedDuelist = <Medication>[];
    final othersList = <Medication>[];
    for (final element in medications) {
      if (element.isAsNeeded()) {
        asNeededList.add(element);
      } else if (element.isDue()) {
        missedDuelist.add(element);
      }
    }

    return Column(
      children: [
        CardStackAnimation(
          medications: asNeededList,
          key: Key('as-needed-cards'),
          takeAllFunction: () => takeAll(asNeededList),
          buttons: confirmQuantityButton,
          title: Strings.asNeeded.toUpperCase(),
        ),
        CardStackAnimation(
          key: Key('meds-due-cards'),
          buttons: skipConfirmButton,
          takeAllFunction: () => takeAll(missedDuelist),
          medications: missedDuelist,
          title: Strings.medsDue.toUpperCase(),
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

  Future<void> takeMedication(List<Medication> medications, int? index) async {
    if (medications.first.nextDosing != null) {
      medications.first.nextDosing!.outcome = DosingOutcome.taken;
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
                takeAllFunction: () => takeAll(similarItems),
                title: getTimeDescription(
                    similarItems.first.nextDosing!.scheduledDosingTime!),
              ),
              if (similarItems.length < 3)
                SizedBox()
              else
                for (var j = 1; j < similarItems.length; j++)
                  LiviThemes.spacing.heightSpacer4(),
            ],
          ),
        );
      }
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
