import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/buttons/livi_inkwell.dart';
import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/enums.dart';
import '../../../models/models.dart';
import '../../../models/schedule_type.dart';
import '../../../services/medication_service.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/string_ext.dart';
import '../../../utils/strings.dart';
import '../../../utils/utils.dart';
import '../../views.dart';

const int _foreverYear = 2200;

class SelectFrequencyPage extends StatefulWidget {
  final bool isEdit;
  static const String routeName = '/select-frequency-page';
  final Medication medication;
  const SelectFrequencyPage({
    super.key,
    required this.medication,
    this.isEdit = false,
  });

  @override
  State<SelectFrequencyPage> createState() => _SelectFrequencyPageState();
}

class _SelectFrequencyPageState extends State<SelectFrequencyPage> {
  DateTime now = DateTime.now();

  ///1h-12h
  List<int> hoursList = List<int>.generate(12, (e) => e + 1);

  ///1-12
  List<int> notToExceedList = List<int>.generate(12, (e) => e + 1);

  ///1-30
  List<int> intervalBetweenDosesList = List<int>.generate(30, (e) => e + 1);

  List<int> minutesList = List.generate(60, (e) => e++);
  List<double> quantityList = List.generate(13, (e) => e + 1);

  IntervalBetweenDoses intervalBetweenDoses = IntervalBetweenDoses.eightHours;
  DayTime? dayTime = DayTime.am;
  // DateTime monthlyOnTheDay = DateTime.now();
  final dateFormat = DateFormat.yMMMMd('en_US');
  int currentIndex = 0;
  bool dropdownIsSelected = false;

  final List<TextEditingController> _startDateController = [
    TextEditingController()
  ];
  final List<TextEditingController> _endDateController = [
    TextEditingController()
  ];
  final List<TextEditingController> _inventoryQuantityController = [
    TextEditingController(text: '30')
  ];

  final List<TextEditingController> _instructionsController = [
    TextEditingController()
  ];

  final FocusNode _inventoryQuantityFocus = FocusNode();

  final FocusNode _instructionsFocus = FocusNode();

  List<Schedule> get schedules => widget.medication.schedules;
  @override
  void initState() {
    dayTime = now.hour > 12 ? DayTime.pm : DayTime.am;

    widget.medication.schedules = [
      Schedule(
        startDate: now,
        scheduledDosings: [ScheduledDose(timeOfDay: TimeOfDay.now())],
        dayPattern: [],
      ),
    ];
    setDate(currentIndex);
    for (final element in _inventoryQuantityController) {
      element.text = widget.medication.inventoryQuantity.toString();
      element.addListener(() {
        setState(() {});
      });
    }

    super.initState();
  }

  void setPrn() {}

  int convert24TimeFormatToAmPm(int hour) {
    if (hour > 12) {
      return hour - 12;
    }
    return hour;
  }

  int convertAmPmTimeFormatTo24(int hour) {
    if (hour < 12 && dayTime == DayTime.pm) {
      return hour + 12;
    }
    return hour;
  }

  void setDate(int index) {
    if (schedules[index].startDate.isSameDayMonthYear(now)) {
      _startDateController[index].text = Strings.now;
    } else {
      _startDateController[index].text =
          dateFormat.format(schedules[index].startDate);
    }
    if (schedules[index].endDate == null) {
      _endDateController[index].text = Strings.forever;
    } else {
      _endDateController[index].text =
          dateFormat.format(schedules[index].endDate!);
    }
    setState(() {});
  }

  bool get getShowInventoryQuantityField =>
      widget.medication.type.isAsNeeded() ||
      widget.medication.type.isDaily() ||
      widget.medication.type.isWeekly() ||
      widget.medication.type.isMonthly();

  bool get getShowQuantityNeededField =>
      widget.medication.type.isAsNeeded() ||
      widget.medication.type.isDaily() ||
      widget.medication.type.isWeekly() ||
      widget.medication.type.isMonthly();

  bool get getShowInstructions =>
      widget.medication.type.isAsNeeded() ||
      widget.medication.type.isDaily() ||
      widget.medication.type.isWeekly() ||
      widget.medication.type.isMonthly();

  bool get getShowDaysWidget => widget.medication.type.isWeekly();

  bool get getAtWhatTimesWidget =>
      widget.medication.type.isWeekly() ||
      widget.medication.type.isMonthly() ||
      widget.medication.type.isDaily();

  bool get getMonthlyOnTheDay => widget.medication.type.isMonthly();

  bool get getRemindMeBefore =>
      widget.medication.type.isWeekly() ||
      widget.medication.type.isMonthly() ||
      widget.medication.type.isDaily();

  bool get getRemindMeLater =>
      widget.medication.type.isWeekly() ||
      widget.medication.type.isMonthly() ||
      widget.medication.type.isDaily();

  bool get getNotToExceed => widget.medication.type.isDaily();

  bool get getIntervalBetweenDoses => widget.medication.type.isAsNeeded();

  // bool get showQuantityNeededField => selectedFrequency.isAsNeeded();
  // bool get showQuantityField => selectedFrequency.isDaily();

  //detect if any of the textcontrollers are empty
  bool get isEnabled =>
      _inventoryQuantityController.any((element) => element.text.isEmpty);

  void goToHomePage() {
    Navigator.popUntil(
      context,
      (route) => route.settings.name == SmsFlowPage.routeName,
    );
  }

  PrnDose prnDose() {
    if (widget.medication.schedules[currentIndex].prnDosing == null) {
      return widget.medication.schedules[currentIndex].prnDosing = PrnDose();
    } else {
      return widget.medication.schedules[currentIndex].prnDosing!;
    }
  }

  List<Widget> listBuilder() {
    return [
      startDateWidget(),
      endDateWidget(),
      if (currentIndex == 0) selectFrequencyWidget(),
      if (getIntervalBetweenDoses) intervalBetweenDosesWidget(),
      if (getShowDaysWidget) daysWidget(),
      if (getAtWhatTimesWidget) monthlyOnTheDayWidget(),
      if (getAtWhatTimesWidget) timeOfDayWidget(),

      // awThatTimesList(),
      if (getRemindMeBefore) remindMeBefore(),
      if (getRemindMeLater) remindMeLater(),
      if (getNotToExceed) notToExceedWidget(),
      if (getShowInventoryQuantityField && currentIndex == 0)
        inventoryQuantityWidget(),
      if (getShowInstructions) instructionsWidget(),

      if (widget.isEdit) deleteScheduleWidget(),

      addAnotherScheduleWidget(schedules.length),
      if (!widget.isEdit) saveWidget(),
    ];
  }

  Future<void> saveMedication() async {
    widget.medication.inventoryQuantity = int.parse(
        _inventoryQuantityController[currentIndex].text.isEmpty
            ? '0'
            : _inventoryQuantityController[currentIndex].text);
    widget.medication.appUserId =
        Provider.of<AuthController>(context, listen: false).appUser!.id;
    widget.medication.instructions = _instructionsController[currentIndex].text;
    goToHomePage();
    if (widget.isEdit) {
      await MedicationService().updateMedication(widget.medication);
      return;
    }
    await MedicationService().createMedication(widget.medication);
  }

  void selectFrequency(ScheduleType frequency) {
//TODO: everytime we change the type schedule we have to reset all the fields...
// if it was daily and we change to weekly we have fill the new fields and reset the old ones? ask bill
    widget.medication.type = frequency;
    setState(() {});
  }

  void deleteMedication() {
    // showModalBottomSheet(
    //   context: context,
    //   builder: (context) => BottomSheet(
    //     onClosing: () {},
    //     builder: (context) => Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         ListTile(
    //           title: Text('Delete Medication'),
    //           onTap: () {
    //             Navigator.pop(context);
    //             deleteMedication();
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    MedicationService().deleteMedication(widget.medication);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        mainWidget: widget.medication.schedules.length > 1
            ? DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  onTap: () {
                    dropdownIsSelected = true;
                  },
                  value: currentIndex,
                  onChanged: (int? value) {
                    currentIndex = value!;
                    dropdownIsSelected = false;
                    setState(() {});
                  },
                  items: dropdownIsSelected
                      ? [
                          DropdownMenuItem(
                            child: LiviTextStyles.interSemiBold16(
                              widget.medication.name,
                            ),
                          )
                        ]
                      : widget.medication.schedules.asMap().entries.map(
                          (entry) {
                            return DropdownMenuItem<int>(
                              value: entry.key,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: LiviTextStyles.interSemiBold16(
                                    'Schedule ${entry.key + 1}',
                                    textAlign: TextAlign.center),
                              ),
                            );
                          },
                        ).toList(),
                ),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: LiviTextStyles.interSemiBold16(widget.medication.name,
                    textAlign: TextAlign.center),
              ),
        title: widget.medication.getNameStrengthDosageForm(),
        onPressed: widget.isEdit ? () {} : null,
        tail: widget.isEdit
            ? [
                LiviTextIcon(
                  onPressed: isEnabled ? goToHomePage : () {},
                  enabled: isEnabled,
                  text: Strings.save,
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: LiviThemes.icons.checkIcon(
                      color: isEnabled
                          ? LiviThemes.colors.brand600
                          : LiviThemes.colors.gray400,
                    ),
                  ),
                )
              ]
            : null,
      ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          LiviThemes.spacing.heightSpacer8(),
          ...listBuilder(),
        ],
      ),
    );
  }

  Widget notToExceedWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interMedium16(Strings.notToExceed,
              color: LiviThemes.colors.gray500),
          LiviThemes.spacing.heightSpacer8(),
          Row(
            children: [
              Expanded(
                child: LiviDropdownButton<int>(
                  isExpanded: true,
                  value: notToExceedList.singleWhere(
                      (element) => element == (prnDose().nteQty),
                      orElse: () => prnDose().nteQty.toInt()),
                  onChanged: (int? value) {
                    prnDose().nteQty = value!.toDouble();
                    setState(() {});
                  },
                  items:
                      notToExceedList.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget selectFrequencyWidget() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interMedium16(Strings.frequency,
              color: LiviThemes.colors.gray500),
          LiviThemes.spacing.heightSpacer8(),
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: LiviThemes.colors.gray300,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                frequencyWidget(ScheduleType.asNeeded, flex: 4),
                divider(),
                frequencyWidget(ScheduleType.daily),
                divider(),
                frequencyWidget(ScheduleType.weekly),
                divider(),
                frequencyWidget(ScheduleType.monthly),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget inventoryQuantityWidget() {
    return LiviInputField(
      title: Strings.inventoryQuantity,
      focusNode: _inventoryQuantityFocus,
      controller: _inventoryQuantityController[currentIndex],
      keyboardType: TextInputType.number,
    );
  }

  Widget instructionsWidget() {
    if (Provider.of<AuthController>(context).appUser!.appUserType !=
        AppUserType.selfGuidedUser) {
      return LiviInputField(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Strings.instructions,
        focusNode: _instructionsFocus,
        maxLines: 2,
        hint: "e.g. Don't drink alcohol when taking this medicine.",
        controller: _instructionsController[currentIndex],
        keyboardType: TextInputType.text,
      );
    } else {
      return SizedBox();
    }
  }

  Widget quantityNeededWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interMedium16(Strings.quantityNeeded,
              color: LiviThemes.colors.gray500),
          LiviThemes.spacing.heightSpacer8(),
          Row(
            children: [
              Expanded(
                child: LiviDropdownButton<double>(
                  isExpanded: true,
                  value: quantityList.singleWhere(
                      (element) =>
                          element ==
                          widget.medication.schedules[currentIndex]
                              .scheduledDosings.first.qty,
                      orElse: () => widget.medication.schedules[currentIndex]
                          .scheduledDosings.first.qty),
                  onChanged: (double? value) {
                    if (widget.medication.type.isAsNeeded()) {
                      setPrn();
                    } else {
                      widget.medication.schedules[currentIndex].scheduledDosings
                          .first.qty = value!;
                    }
                    setState(() {});
                  },
                  items: quantityList
                      .map<DropdownMenuItem<double>>((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: Text(value.toInt().toString()),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget intervalBetweenDosesWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interMedium16(Strings.intervalBetweenDoses,
              color: LiviThemes.colors.gray500),
          LiviThemes.spacing.heightSpacer8(),
          Row(
            children: [
              Expanded(
                child: LiviDropdownButton<int>(
                  isExpanded: true,
                  value: intervalBetweenDosesList.singleWhere(
                      (element) => element == (prnDose().hourInterval),
                      orElse: () => prnDose().nteQty.toInt()),
                  onChanged: (int? value) {
                    prnDose().hourInterval = value!;
                    setState(() {});
                  },
                  items: intervalBetweenDosesList
                      .map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value hours'),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Container(
      width: 1,
      color: LiviThemes.colors.gray300,
    );
  }

  Widget startDateWidget() {
    return LiviInputField(
      title: Strings.startDate,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      focusNode: FocusNode(),
      onTap: () => showMaterialDatePicker(
          context: context,
          initialDate: now,
          firstDate: now,
          lastDate: DateTime(_foreverYear),
          isStartDate: true),
      readOnly: true,
      controller: _startDateController[currentIndex],
      prefix: Padding(
        padding: const EdgeInsets.all(16),
        child: LiviThemes.icons.calendarIcon(),
      ),
    );
  }

  Widget endDateWidget() {
    return LiviInputField(
      title: Strings.endDate,
      focusNode: FocusNode(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      readOnly: true,
      onTap: () => showMaterialDatePicker(
        context: context,
        isStartDate: false,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(_foreverYear),
      ),
      controller: _endDateController[currentIndex],
      prefix: Padding(
        padding: const EdgeInsets.all(16),
        child: LiviThemes.icons.calendarIcon(),
      ),
    );
  }

  Widget remindMeBefore() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interMedium16(Strings.remindMe,
              color: LiviThemes.colors.gray500),
          LiviThemes.spacing.heightSpacer8(),
          Row(
            children: [
              Expanded(
                child: LiviDropdownButton<TimeReminderBefore>(
                  isExpanded: true,
                  value: TimeReminderBefore.values.singleWhere(
                      (element) =>
                          element == schedules[currentIndex].timeReminderBefore,
                      orElse: () => schedules[currentIndex].timeReminderBefore),
                  onChanged: (TimeReminderBefore? value) {
                    setState(() {
                      schedules[currentIndex].timeReminderBefore = value!;
                    });
                  },
                  items: TimeReminderBefore.values
                      .map<DropdownMenuItem<TimeReminderBefore>>(
                          (TimeReminderBefore value) {
                    return DropdownMenuItem<TimeReminderBefore>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget remindMeLater() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interMedium16(Strings.remindMe,
              color: LiviThemes.colors.gray500),
          LiviThemes.spacing.heightSpacer8(),
          Row(
            children: [
              Expanded(
                child: LiviDropdownButton<TimeReminderLater>(
                  isExpanded: true,
                  value: TimeReminderLater.values.singleWhere(
                      (element) =>
                          element == schedules[currentIndex].timeReminderLater,
                      orElse: () => schedules[currentIndex].timeReminderLater),
                  onChanged: (TimeReminderLater? value) {
                    setState(() {
                      schedules[currentIndex].timeReminderLater = value!;
                    });
                  },
                  items: TimeReminderLater.values
                      .map<DropdownMenuItem<TimeReminderLater>>(
                          (TimeReminderLater value) {
                    return DropdownMenuItem<TimeReminderLater>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//TODO block end date bvy intial date
  Future<void> showMaterialDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required bool isStartDate,
    required,
  }) async {
    final dateTime = await showDatePicker(
      context: context,
      cancelText: isStartDate ? Strings.now : Strings.forever,
      confirmText: Strings.apply,
      initialDate: isStartDate ? now : schedules[currentIndex].startDate,
      firstDate: isStartDate
          ? now
          : schedules[currentIndex]
              .startDate, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(_foreverYear),
    );
    if (dateTime == null) {
      if (isStartDate) {
        schedules[currentIndex].startDate = now;
      } else {
        schedules[currentIndex].endDate = dateTime;
      }
    } else {
      if (isStartDate) {
        schedules[currentIndex].startDate = dateTime;
      } else {
        schedules[currentIndex].endDate = dateTime;
      }
    }
    setDate(currentIndex);
  }

  Widget frequencyWidget(ScheduleType frequency, {int flex = 3}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => selectFrequency(frequency),
        child: Ink(
          height: double.maxFinite,
          decoration: BoxDecoration(
              color: widget.medication.type == frequency
                  ? LiviThemes.colors.brand50
                  : LiviThemes.colors.baseWhite),
          child: Align(
            child: LiviTextStyles.interBold14(frequency.description,
                color: widget.medication.type == frequency
                    ? LiviThemes.colors.brand600
                    : LiviThemes.colors.gray500),
          ),
        ),
      ),
    );
  }

  Widget daysWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interSemiBold14(Strings.days),
          LiviThemes.spacing.heightSpacer16(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dayWidget(DateTime.sunday),
              dayWidget(DateTime.monday),
              dayWidget(DateTime.tuesday),
              dayWidget(DateTime.wednesday),
              dayWidget(DateTime.thursday),
              dayWidget(DateTime.friday),
              dayWidget(DateTime.saturday),
            ],
          ),
        ],
      ),
    );
  }

  Widget deleteScheduleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LiviFilledButtonWhite(
        text: Strings.deleteSchedule,
        textColor: LiviThemes.colors.baseBlack,
        onTap: deleteMedication,
      ),
    );
  }

  Widget addAnotherScheduleWidget(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: LiviFilledButtonWhite(
        text: Strings.newSchedule,
        textColor: LiviThemes.colors.baseBlack,
        onTap: () {
          //TODO: add schedule dose here
          schedules.add(
            Schedule(
              startDate: now,
              scheduledDosings: [
                ScheduledDose(
                  timeOfDay: TimeOfDay.now(),
                )
              ],
            ),
          );
          _startDateController.add(TextEditingController());
          _endDateController.add(TextEditingController());
          _inventoryQuantityController.add(TextEditingController(text: '30'));
          _instructionsController.add(TextEditingController());

          setDate(index);
          currentIndex = schedules.length - 1;
          setState(() {});
        },
      ),
    );
  }

  Widget saveWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        child: LiviFilledButton(
          margin: EdgeInsets.symmetric(horizontal: 64),
          text: Strings.save,
          onTap: () => saveMedication(),
        ),
      ),
    );
  }

  Widget dayWidget(int dayOfWeek, {int flex = 1}) {
    return InkWell(
      onTap: () {
        if (schedules[currentIndex].dayPattern != null) {
          if (schedules[currentIndex].dayPattern!.contains(dayOfWeek)) {
            schedules[currentIndex].dayPattern!.remove(dayOfWeek);
          } else {
            schedules[currentIndex].dayPattern!.add(dayOfWeek);
          }
          setState(() {});
        }
      },
      child: Ink(
        height: (MediaQuery.of(context).size.width - 92) / 7,
        width: (MediaQuery.of(context).size.width - 92) / 7,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: schedules[currentIndex].dayPattern != null &&
                    schedules[currentIndex].dayPattern!.contains(dayOfWeek)
                ? LiviThemes.colors.brand600
                : dayOfWeek.isWeekend()
                    ? LiviThemes.colors.brand50
                    : LiviThemes.colors.baseWhite,
            border: Border.all(
                color: LiviThemes.colors.gray300,
                width: dayOfWeek.isWeekend() ? 0 : 1)),
        child: Align(
          child: LiviTextStyles.interRegular16(
              getStringFromDateTimeInteger(dayOfWeek).getFirstLetter(),
              color: schedules[currentIndex].dayPattern != null &&
                      schedules[currentIndex].dayPattern!.contains(dayOfWeek)
                  ? LiviThemes.colors.baseWhite
                  : dayOfWeek.isWeekend()
                      ? LiviThemes.colors.brand600
                      : LiviThemes.colors.baseBlack),
        ),
      ),
    );
  }

  Widget monthlyOnTheDayWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interMedium16(Strings.monthlyOnTheDay,
              color: LiviThemes.colors.gray500),
          LiviThemes.spacing.heightSpacer8(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: LiviThemes.colors.gray300,
              ),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: schedules[currentIndex].monthPattern!.length,
                itemBuilder: (context, index) {
                  final item = schedules[currentIndex].monthPattern![index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LiviTextStyles.interRegular16(
                                'Every ${formartDay(item)}'),
                            IconCircleBox(
                              onTap: () {
                                schedules[currentIndex].monthPattern!.removeAt(
                                      index,
                                    );
                                setState(() {});
                              },
                              padding: EdgeInsets.zero,
                              color: LiviThemes.colors.error500,
                              child: LiviThemes.icons.minusWidget(),
                            ),
                          ],
                        ),
                      ),
                      LiviDivider(),
                    ],
                  );
                },
              ),
              LiviDivider(),
              LiviInkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  schedules[currentIndex]
                      .monthPattern!
                      .add(Random().nextInt(31));
                  setState(() {});
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      IconCircleBox(
                          child: LiviThemes.icons.plusIcon(
                              color: LiviThemes.colors.baseWhite, height: 16)),
                      LiviThemes.spacing.widthSpacer8(),
                      LiviTextStyles.interMedium16(Strings.addDay,
                          color: LiviThemes.colors.brand600),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget timeOfDayWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interMedium16(Strings.timeOfDay,
              color: LiviThemes.colors.gray500),
          LiviThemes.spacing.heightSpacer8(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: LiviThemes.colors.gray300,
              ),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: schedules[currentIndex].scheduledDosings.length,
                itemBuilder: (context, index) {
                  final item = schedules[currentIndex].scheduledDosings[index];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LiviTextStyles.interRegular16(
                                'Take ${item.qty.toInt()} at ${item.timeOfDay.hour}:${item.timeOfDay.minute}'),
                            IconCircleBox(
                              onTap: () {
                                schedules[currentIndex]
                                    .scheduledDosings
                                    .removeAt(index);
                                setState(() {});
                              },
                              padding: EdgeInsets.zero,
                              color: LiviThemes.colors.error500,
                              child: LiviThemes.icons.minusWidget(),
                            ),
                          ],
                        ),
                      ),
                      LiviDivider(),
                    ],
                  );
                },
              ),
              LiviDivider(),
              Row(
                children: [
                  LiviInkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: () {
                      schedules[currentIndex].scheduledDosings.add(
                            ScheduledDose(
                              timeOfDay: TimeOfDay.now(),
                            ),
                          );
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          IconCircleBox(
                              child: LiviThemes.icons.plusIcon(
                                  color: LiviThemes.colors.baseWhite,
                                  height: 16)),
                          LiviThemes.spacing.widthSpacer8(),
                          LiviTextStyles.interMedium16(Strings.addTime,
                              color: LiviThemes.colors.brand600),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
