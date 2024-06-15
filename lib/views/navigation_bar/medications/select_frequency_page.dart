import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  Medication medication;
  SelectFrequencyPage({
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

  final TextEditingController _takeDosesController = TextEditingController();
  TimeOfDay? _timeOfDay;

  final List<TextEditingController> _startDateController = [
    TextEditingController()
  ];
  final List<TextEditingController> _endDateController = [
    TextEditingController()
  ];
  final TextEditingController _inventoryQuantityController =
      TextEditingController(text: '30');
  final List<TextEditingController> _quantityController = [
    TextEditingController(text: '1')
  ];

  final TextEditingController _instructionsController = TextEditingController();

  final FocusNode _inventoryQuantityFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();

  final FocusNode _instructionsFocus = FocusNode();

  List<Schedule> get schedules => widget.medication.schedules;
  bool get isForever => schedules[currentIndex]
      .endDate
      .isSameDayMonthYear(schedules[currentIndex].startDate);
  @override
  void initState() {
    dayTime = now.hour > 12 ? DayTime.pm : DayTime.am;

    if (widget.isEdit) {
      _inventoryQuantityController.text =
          widget.medication.inventoryQuantity.toString();
      for (var i = 0; i < schedules.length; i++) {
        _startDateController.add(TextEditingController());
        _endDateController.add(TextEditingController());
        _instructionsController.text = widget.medication.instructions;
        _quantityController.add(TextEditingController(
            text: schedules[i].prnDosing?.maxQty.toInt().toString()));
        setDate(i);
      }
    } else {
      widget.medication.schedules = [
        Schedule(
          startDate: DateTime(now.year, now.month, now.day),
          endDate: DateTime(now.year, now.month, now.day),
          scheduledDosings: [
            ScheduledDose(timeOfDay: TimeOfDay(hour: 8, minute: 0))
          ],
        ),
      ];
      schedules.first.prnDosing = PrnDose();
      setDate(currentIndex);
    }
    _inventoryQuantityController.addListener(() {
      setState(() {});
    });
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
    if (isForever) {
      _endDateController[index].text = Strings.forever;
    } else {
      _endDateController[index].text =
          dateFormat.format(schedules[index].endDate);
    }
    setState(() {});
  }

  bool get getShowInventoryQuantityField =>
      schedules.first.type.isAsNeeded() ||
      schedules.first.type.isDaily() ||
      schedules.first.type.isWeekly() ||
      schedules.first.type.isMonthly();

  bool get getShowQuantityNeededField =>
      schedules.first.type.isAsNeeded() ||
      schedules.first.type.isDaily() ||
      schedules.first.type.isWeekly() ||
      schedules.first.type.isMonthly();

  bool get getShowInstructions =>
      schedules.first.type.isAsNeeded() ||
      schedules.first.type.isDaily() ||
      schedules.first.type.isWeekly() ||
      schedules.first.type.isMonthly();

  bool get getShowDaysWidget => schedules.first.type.isWeekly();

  bool get getAtWhatTimesWidget =>
      schedules.first.type.isWeekly() ||
      schedules.first.type.isMonthly() ||
      schedules.first.type.isDaily();

  bool get getMonthlyOnTheDay => schedules.first.type.isMonthly();

  bool get getQuantity => schedules.first.type.isAsNeeded();

  bool get getRemindMeBefore =>
      schedules.first.type.isWeekly() ||
      schedules.first.type.isMonthly() ||
      schedules.first.type.isDaily();

  bool get getRemindMeLater =>
      schedules.first.type.isWeekly() ||
      schedules.first.type.isMonthly() ||
      schedules.first.type.isDaily();

  bool get getNotToExceed => schedules.first.type.isAsNeeded();

  bool get getIntervalBetweenDoses => schedules.first.type.isAsNeeded();

  // bool get showQuantityNeededField => selectedFrequency.isAsNeeded();
  // bool get showQuantityField => selectedFrequency.isDaily();

  //detect if any of the textcontrollers are empty
  bool get isEnabled => _inventoryQuantityController.text.isNotEmpty;

  void goToHomePage() {
    Navigator.popUntil(
      context,
      (route) => route.settings.name == SmsFlowPage.routeName,
    );
  }

  PrnDose prnDose() {
    if (schedules[currentIndex].prnDosing == null) {
      return schedules[currentIndex].prnDosing = PrnDose();
    } else {
      return schedules[currentIndex].prnDosing!;
    }
  }

  List<Widget> listBuilder() {
    return [
      startDateWidget(),
      endDateWidget(),
      if (currentIndex == 0) selectFrequencyWidget(),
      if (getIntervalBetweenDoses) intervalBetweenDosesWidget(),
      if (getQuantity) quantityWidget(),
      if (getShowDaysWidget) daysWidget(),
      if (getMonthlyOnTheDay) monthlyOnTheDayWidget(),
      if (getAtWhatTimesWidget) timeOfDayWidget(),

      // awThatTimesList(),
      if (getRemindMeBefore) remindMeBefore(),
      if (getRemindMeLater) remindMeLater(),
      if (getNotToExceed) notToExceedWidget(),
      if (getShowInventoryQuantityField && currentIndex == 0)
        inventoryQuantityWidget(),
      if (getShowInstructions && currentIndex == 0) instructionsWidget(),
      LiviThemes.spacing.heightSpacer16(),
      if (widget.isEdit && schedules.length > 1) deleteScheduleWidget(),
      if (widget.isEdit) deleteMedicationWidget(),
      if (!widget.isEdit) addAnotherScheduleWidget(schedules.length),
      if (!widget.isEdit) saveWidget(),
    ];
  }

  Future<void> saveMedication() async {
    for (final element in schedules) {
      if (schedules.first.type == ScheduleType.asNeeded) {
        element.scheduledDosings = [];
      } else {
        element.prnDosing = null;
      }
    }
    widget.medication.inventoryQuantity = int.parse(
        _inventoryQuantityController.text.isEmpty
            ? '0'
            : _inventoryQuantityController.text);

    if (schedules.first.prnDosing != null) {
      for (var i = 0; i < schedules.length; i++) {
        if (_quantityController[i].text.isNotEmpty) {
          widget.medication.schedules[i].prnDosing!.maxQty =
              double.parse(_quantityController[i].text);
        }
      }
    }

    widget.medication.appUserId =
        Provider.of<AuthController>(context, listen: false).appUser!.id;
    widget.medication.instructions = _instructionsController.text;
    goToHomePage();
    if (widget.isEdit) {
      await MedicationService().updateMedication(widget.medication);
      return;
    }
    await MedicationService().createMedication(widget.medication);
  }

  void selectFrequency(ScheduleType scheduleType) {
    final backup = widget.medication;
    widget.medication = Medication(name: backup.name);
    widget.medication.schedules = backup.schedules;
    widget.medication.strength = backup.strength;
    widget.medication.dosageForm = backup.dosageForm;

    for (final element in schedules) {
      element.type = scheduleType;
    }

    setState(() {});
  }

  void deleteMedication() {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)), //this right here
              child: Container(
                height: 320,
                width: 400.0,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconCircleBox(
                          padding: EdgeInsets.all(12),
                          color: LiviThemes.colors.error50,
                          child: LiviThemes.icons
                              .trash1Icon(color: LiviThemes.colors.error600),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: LiviThemes.icons.closeIcon(
                            color: LiviThemes.colors.gray300,
                          ),
                        ),
                      ],
                    ),
                    LiviThemes.spacing.heightSpacer8(),
                    LiviTextStyles.interSemiBold18(
                        '${Strings.delete} ${widget.medication.getNameStrengthDosageForm()}?'),
                    LiviTextStyles.interRegular16(
                        Strings.areYouSureYouWantToDelete),
                    Spacer(),
                    LiviFilledButton(
                      color: LiviThemes.colors.error600,
                      text: Strings.deleteMedication,
                      onTap: () {
                        MedicationService().deleteMedication(widget.medication);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                    LiviThemes.spacing.heightSpacer12(),
                    LiviFilledButtonWhite(
                      onTap: () => Navigator.pop(context),
                      text: Strings.cancel,
                      textColor: LiviThemes.colors.baseBlack,
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        mainWidget: schedules.length > 1
            ? DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  hint: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: LiviTextStyles.interSemiBold16(
                        widget.medication.getNameStrengthDosageForm(),
                        maxLines: 1),
                  ),
                  value: null,
                  onChanged: (int? value) {
                    currentIndex = value!;
                    dropdownIsSelected = false;
                    setState(() {});
                  },
                  items: schedules.asMap().entries.map(
                    (entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: SizedBox(
                          width: widget.isEdit
                              ? MediaQuery.of(context).size.width * 0.3
                              : MediaQuery.of(context).size.width * 0.45,
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
                child: LiviTextStyles.interSemiBold16(
                    widget.medication.getNameStrengthDosageForm(),
                    textAlign: TextAlign.center),
              ),
        title: widget.medication.getNameStrengthDosageForm(),
        onPressed: widget.isEdit ? () {} : null,
        tail: widget.isEdit
            ? [
                LiviTextIcon(
                  onPressed: isEnabled ? saveMedication : () {},
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
          LiviTextStyles.interMedium16(Strings.scheduleType,
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
      controller: _inventoryQuantityController,
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
        controller: _instructionsController,
        keyboardType: TextInputType.text,
      );
    } else {
      return SizedBox();
    }
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
          initialDate: startDateValue(),
          firstDate: startDateValue(),
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

  DateTime startDateValue({bool stillAdding = false}) {
    if (stillAdding) {
      return schedules[currentIndex].endDate.add(Duration(minutes: 1));
    }
    if (schedules.length < 2) {
      return now;
    }
    return schedules[currentIndex - 1].endDate.add(Duration(minutes: 1));
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
        initialDate: startDateValue(),
        firstDate: startDateValue(),
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
                          element.duration.inMinutes ==
                          schedules[currentIndex].startWarningMinutes,
                      orElse: () => TimeReminderBefore.oneMinute),
                  onChanged: (TimeReminderBefore? value) {
                    setState(() {
                      schedules[currentIndex].startWarningMinutes =
                          value!.duration.inMinutes;
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
                          element.duration.inMinutes ==
                          schedules[currentIndex].stopWarningMinutes,
                      orElse: () => TimeReminderLater.oneMinute),
                  onChanged: (TimeReminderLater? value) {
                    setState(() {
                      schedules[currentIndex].stopWarningMinutes =
                          value!.duration.inMinutes;
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

  Future<void> showTimerPickerWidget(StateSetter setStates) async {
    _timeOfDay = (await showTimePicker(
          context: context,
          cancelText: Strings.cancel,
          confirmText: Strings.ok,
          initialTime: _timeOfDay ?? TimeOfDay(hour: 8, minute: 0),
        )) ??
        TimeOfDay(hour: 8, minute: 0);
    setStates(() {});
    setState(() {});
  }

  Future<void> showMaterialDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required bool isStartDate,
  }) async {
    final dateTime = await showDatePicker(
      context: context,
      cancelText: isStartDate ? Strings.now : Strings.forever,
      confirmText: Strings.apply,
      initialDate:
          isStartDate ? initialDate : schedules[currentIndex].startDate,
      firstDate: isStartDate
          ? firstDate
          : schedules[currentIndex]
              .startDate, //DateTime.now() - not to allow to choose before today.
      lastDate: isForever || !isStartDate
          ? DateTime(_foreverYear)
          : schedules[currentIndex].endDate,
    );
    if (dateTime == null) {
      if (isStartDate) {
        schedules[currentIndex].startDate = now;
      } else {
        if (dateTime == null) {
          schedules[currentIndex].endDate = schedules[currentIndex].startDate;
        } else {
          schedules[currentIndex].endDate = dateTime.wholeDay();
        }
      }
    } else {
      if (isStartDate) {
        schedules[currentIndex].startDate = dateTime;
        if (schedules[currentIndex]
            .endDate
            .isBefore(schedules[currentIndex].startDate)) {
          schedules[currentIndex].endDate = dateTime;
        }
      } else {
        if (dateTime == null) {
          schedules[currentIndex].endDate = schedules[currentIndex].startDate;
        } else {
          schedules[currentIndex].endDate = dateTime.wholeDay();
        }
      }
    }
    setDate(currentIndex);
  }

  Widget frequencyWidget(ScheduleType scheduleType, {int flex = 3}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => selectFrequency(scheduleType),
        child: Ink(
          height: double.maxFinite,
          decoration: BoxDecoration(
              color: schedules.first.type == scheduleType
                  ? LiviThemes.colors.brand50
                  : LiviThemes.colors.baseWhite),
          child: Align(
            child: LiviTextStyles.interBold14(scheduleType.description,
                color: schedules.first.type == scheduleType
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
              dayWidget(Days.sunday.index),
              dayWidget(Days.monday.index),
              dayWidget(Days.tuesday.index),
              dayWidget(Days.wednesday.index),
              dayWidget(Days.thursday.index),
              dayWidget(Days.friday.index),
              dayWidget(Days.saturday.index),
            ],
          ),
        ],
      ),
    );
  }

  void deleteSchedule() {
    schedules.removeAt(currentIndex);
    if (currentIndex != 0) {
      currentIndex--;
    }
    setDate(currentIndex);
    setState(() {});
  }

  Widget deleteScheduleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LiviFilledButtonWhite(
          text: Strings.deleteSchedule,
          textColor: LiviThemes.colors.baseBlack,
          onTap: deleteSchedule),
    );
  }

  Widget deleteMedicationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LiviFilledButton(
        color: LiviThemes.colors.error600,
        text: Strings.deleteMedication,
        onTap: deleteMedication,
      ),
    );
  }

  void createNewSchedule(int index) {
    if (isForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        LiviSnackBar()
            .liviSnackBar(text: Strings.cannotCreateSchedule, isError: true),
      );
      return;
    }
    schedules.add(
      Schedule(
        startDate: startDateValue(stillAdding: true),
        endDate: startDateValue(stillAdding: true).add(Duration(days: 1)),
        scheduledDosings: [
          ScheduledDose(
            timeOfDay: TimeOfDay.now(),
          )
        ],
      ),
    );
    _startDateController.add(TextEditingController());
    _endDateController.add(TextEditingController());
    _quantityController.add(TextEditingController(text: '1'));

    setDate(index);
    currentIndex = schedules.length - 1;
    setState(() {});
  }

  Widget addAnotherScheduleWidget(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LiviFilledButtonWhite(
        text: Strings.newSchedule,
        textColor: LiviThemes.colors.baseBlack,
        onTap: () => createNewSchedule(index),
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
          if (schedules[currentIndex].dayPattern[dayOfWeek] == 0) {
            schedules[currentIndex].dayPattern[dayOfWeek] = 1;
          } else {
            schedules[currentIndex].dayPattern[dayOfWeek] = 0;
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
                    schedules[currentIndex].dayPattern[dayOfWeek] == 1
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
                      schedules[currentIndex].dayPattern[dayOfWeek] == 1
                  ? LiviThemes.colors.baseWhite
                  : dayOfWeek.isWeekend()
                      ? LiviThemes.colors.brand600
                      : LiviThemes.colors.baseBlack),
        ),
      ),
    );
  }

  Widget buildDaysOfMonthSelector(StateSetter setStates) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      shrinkWrap: true,
      crossAxisCount: 6,
      children:
          // widget.medication.schedules.first.monthPattern
          //     .map((e) => Text(e.toString()))
          //     .toList(),
          getDaysOfMonth(setStates),
    );
  }

  Color getBackgroundColor(int index) {
    if (schedules[currentIndex].monthPattern[index] == 1) {
      return LiviThemes.colors.brand600;
    }
    return LiviThemes.colors.transparent;
  }

  Color getTextColor(int index) {
    if (schedules[currentIndex].monthPattern[index] == 1) {
      return LiviThemes.colors.baseWhite;
    }
    return LiviThemes.colors.baseBlack;
  }

  List<Widget> getDaysOfMonth(StateSetter setStates) {
    final list = <Widget>[];

    for (var i = 0; i < 31; i++) {
      final btn = SizedBox(
        width: 50,
        height: 50,
        child: InkWell(
            borderRadius: BorderRadius.circular(64),
            onTap: () {
              if (schedules[currentIndex].monthPattern != null) {
                if (schedules[currentIndex].monthPattern[i] == 0) {
                  schedules[currentIndex].monthPattern[i] = 1;
                } else {
                  schedules[currentIndex].monthPattern[i] = 0;
                }
                setStates(() {});
              }
            },
            child: IconCircleBox(
              color: getBackgroundColor(i),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (i + 1).toString(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: LiviThemes.typography.interRegular_16
                      .copyWith(color: getTextColor(i)),
                ),
              ),
            )),
      );
      list.add(btn);
    }

    return list;
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
                itemCount: schedules[currentIndex].monthPattern.length,
                itemBuilder: (context, index) {
                  final item = schedules[currentIndex].monthPattern[index];
                  if (item == 1) {
                    return Column(
                      children: [
                        LiviInkWell(
                          splashFactory: NoSplash.splashFactory,
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                LiviTextStyles.interRegular16(
                                    '${Strings.every} ${formartDay(index + 1)}'),
                                IconCircleBox(
                                  onTap: () => removeDayOfMonth(index),
                                  padding: EdgeInsets.zero,
                                  color: LiviThemes.colors.error500,
                                  child: LiviThemes.icons.minusWidget(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        LiviDivider(),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              LiviDivider(),
              LiviInkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: showDaysOfMonth,
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

  Future<void> showDaysOfMonth() async {
    final list = <int>[];
    list.addAll(schedules[currentIndex].monthPattern);
    final cancel = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 20),
                title: const Text(Strings.selectDates),
                content: SizedBox(
                    height: 300,
                    width: 400,
                    child: buildDaysOfMonthSelector(setState)),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text(Strings.cancel),
                    onPressed: () {
                      const cancel = true;
                      Navigator.of(context).pop(cancel);
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text(Strings.ok),
                    onPressed: () {
                      const cancel = false;
                      Navigator.of(context).pop(cancel);
                    },
                  ),
                ],
              ),
            ));
    if (cancel == true) {
      schedules[currentIndex].monthPattern = list;
    }

    setState(() {});
  }

  Future<void> showDialogTime({int? editIndex, ScheduledDose? dose}) async {
    if (editIndex != null && dose != null) {
      _takeDosesController.text = dose.qty.toInt().toString();
      _timeOfDay = dose.timeOfDay;
    } else {
      _takeDosesController.text = '1';
      _timeOfDay = TimeOfDay(hour: 8, minute: 0);
    }
    final scheduleDoses = await showDialog<ScheduledDose>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: LiviThemes.colors.baseWhite,
          surfaceTintColor: LiviThemes.colors.baseWhite,
          insetPadding: EdgeInsets.symmetric(horizontal: 32),
          title: const Text(Strings.enterDates),
          content: Container(
            height: 250,
            width: 400,
            color: LiviThemes.colors.baseWhite,
            child: Column(
              children: [
                LiviThemes.spacing.heightSpacer64(),
                LiviDivider(),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: Strings.take,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        focusNode: FocusNode(),
                        keyboardType: TextInputType.number,
                        controller: _takeDosesController,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: Strings.at,
                              hintText: _timeOfDay == null
                                  ? formartTimeOfDay(
                                      TimeOfDay(hour: 8, minute: 0))
                                  : formartTimeOfDay(_timeOfDay!)),
                          readOnly: true,
                          onTap: () async => showTimerPickerWidget(setState)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(Strings.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(Strings.ok),
              onPressed: () {
                Navigator.of(context).pop(ScheduledDose(
                    timeOfDay: _timeOfDay ??
                        TimeOfDay(hour: now.hour, minute: now.minute),
                    qty: double.parse(_takeDosesController.text)));
              },
            ),
          ],
        ),
      ),
    );
    if (editIndex != null && dose != null && scheduleDoses != null) {
      schedules[currentIndex].scheduledDosings[editIndex] = scheduleDoses;
      setState(() {});
      return;
    } else if (scheduleDoses != null) {
      schedules[currentIndex].scheduledDosings.add(scheduleDoses);
    }
    setState(() {});
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
                      InkWell(
                        onTap: () =>
                            showDialogTime(editIndex: index, dose: item),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LiviTextStyles.interRegular16(
                                  'Take ${item.qty.toInt()} at ${formartTimeOfDay(item.timeOfDay)}'),
                              IconCircleBox(
                                tapPadding: EdgeInsets.fromLTRB(48, 16, 16, 16),
                                onTap: () => removeScheduleDose(index),
                                padding: EdgeInsets.zero,
                                color: LiviThemes.colors.error500,
                                child: LiviThemes.icons.minusWidget(),
                              ),
                            ],
                          ),
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
                    onTap: showDialogTime,
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

  void removeScheduleDose(int index) {
    if (schedules[currentIndex].scheduledDosings.length > 1) {
      schedules[currentIndex].scheduledDosings.removeAt(index);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        LiviSnackBar()
            .liviSnackBar(text: Strings.lastScheduleDoseError, isError: true),
      );
    }
  }

  Widget quantityWidget() {
    return LiviInputField(
      title: Strings.quantity,
      focusNode: _quantityFocus,
      controller: _quantityController[currentIndex],
      keyboardType: TextInputType.number,
    );
  }

  void removeDayOfMonth(int index) {
    final oneList =
        schedules[currentIndex].monthPattern.where((index) => index == 1);
    if (oneList.length > 1) {
      final list = <int>[];
      list.addAll(schedules[currentIndex].monthPattern);
      list[index] = 0;
      schedules[currentIndex].monthPattern = list;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        LiviSnackBar()
            .liviSnackBar(text: Strings.lastDayOfTheMonth, isError: true),
      );
    }
  }
}
