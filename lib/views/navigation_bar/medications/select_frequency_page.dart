import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/enums.dart';
import '../../../models/models.dart';
import '../../../models/schedule_type.dart';
import '../../../services/medication_history.dart';
import '../../../services/medication_service.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/string_ext.dart';
import '../../../utils/strings.dart';
import '../../../utils/utils.dart';
import '../../views.dart';

const int _foreverYear = 2200;

class SelectFrequencyPage extends StatefulWidget {
  static const String routeName = '/select-frequency-page';
  final Medication medication;
  const SelectFrequencyPage({
    super.key,
    required this.medication,
  });

  @override
  State<SelectFrequencyPage> createState() => _SelectFrequencyPageState();
}

class _SelectFrequencyPageState extends State<SelectFrequencyPage> {
  DateTime now = DateTime.now();
  List<int> hoursList = List.generate(13, (index) => index++);

  List<int> minutesList = List.generate(60, (index) => index++);
  List<double> quantityList = List.generate(13, (index) => index + 1);

  IntervalBetweenDoses intervalBetweenDoses = IntervalBetweenDoses.eightHours;
  DayTime? dayTime = DayTime.am;
  // DateTime monthlyOnTheDay = DateTime.now();
  final dateFormat = DateFormat.yMMMMd('en_US');

  final List<TextEditingController> _startDateController = [
    TextEditingController()
  ];
  final List<TextEditingController> _endDateController = [
    TextEditingController()
  ];
  final TextEditingController _inventoryQuantityController =
      TextEditingController();
  final FocusNode _inventoryQuantityFocus = FocusNode();

  List<Schedule> get schedules => widget.medication.schedules;
  @override
  void initState() {
    dayTime = now.hour > 12 ? DayTime.pm : DayTime.am;
    widget.medication.schedules = [
      Schedule(
        scheduledDosings: [ScheduledDose(timeOfDay: TimeOfDay.now())],
        dayPattern: [],
      ),
    ];
    setDate(0);
    _inventoryQuantityController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  int convertTimeFormat(int hour) {
    if (hour > 11) {
      return hour - 12;
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

  bool get getShowDaysWidget => widget.medication.type.isWeekly();

  bool get getAtWhatTimesWidget =>
      widget.medication.type.isWeekly() ||
      widget.medication.type.isMonthly() ||
      widget.medication.type.isDaily();

  bool get getRemindMeBefore =>
      widget.medication.type.isWeekly() ||
      widget.medication.type.isMonthly() ||
      widget.medication.type.isDaily();

  bool get getRemindMeLater =>
      widget.medication.type.isWeekly() ||
      widget.medication.type.isMonthly() ||
      widget.medication.type.isDaily();

  bool get getIntervalBetweenDoses => widget.medication.type.isAsNeeded();

  // bool get showQuantityNeededField => selectedFrequency.isAsNeeded();
  // bool get showQuantityField => selectedFrequency.isDaily();
  bool get isEnabled => _inventoryQuantityController.text.isNotEmpty;

  void goToHomePage() {
    Navigator.popUntil(
      context,
      (route) => route.settings.name == SmsFlowPage.routeName,
    );
  }

  List<Widget> listBuilder(int index) {
    return [
      if (index == 0) selectFrequencyWidget(index),

      if (getShowInventoryQuantityField && index == 0)
        inventoryQuantityWidget(index),
      if (getShowDaysWidget) daysWidget(index),
      if (getShowQuantityNeededField) quantityNeededWidget(index),
      if (getIntervalBetweenDoses) intervalBetweenDosesWidget(index),
      if (getAtWhatTimesWidget) atWhatTimesWidget(index),
      // awThatTimesList(),
      if (getRemindMeBefore) remindMeBefore(index),
      if (getRemindMeLater) remindMeLater(index),
      startDateWidget(index),
      endDateWidget(index),
      if (index == schedules.length - 1) addAnotherScheduleWidget(),
      if (index != schedules.length - 1) LiviDivider(height: 10),
    ];
  }

  Future<void> saveMedication() async {
    widget.medication.inventoryQuantity = int.parse(
        _inventoryQuantityController.text.isEmpty
            ? '0'
            : _inventoryQuantityController.text);
    widget.medication.appUserId =
        Provider.of<AuthController>(context, listen: false).appUser!.id;
    goToHomePage();
    await MedicationService().createMedication(widget.medication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        ///TODO: we need to see all the required fields
        ///and check if all THE REQUIREDS fields are filled :)
        title: widget.medication.name,
        onPressed: () {},
        tail: [
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
        ],
      ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          LiviThemes.spacing.heightSpacer8(),
          for (int i = 0; i < schedules.length; i++) ...listBuilder(i)
        ],
      ),
    );
  }

  Widget selectFrequencyWidget(int index) {
    return Container(
      height: 40,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: LiviThemes.colors.gray300,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          frequencyWidget(ScheduleType.asNeeded, index, flex: 4),
          divider(),
          frequencyWidget(ScheduleType.daily, index),
          divider(),
          frequencyWidget(ScheduleType.weekly, index),
          divider(),
          frequencyWidget(ScheduleType.monthly, index),
        ],
      ),
    );
  }

  Widget inventoryQuantityWidget(int index) {
    return LiviInputField(
      title: Strings.inventoryQuantity.requiredSymbol(),
      focusNode: _inventoryQuantityFocus,
      controller: _inventoryQuantityController,
      keyboardType: TextInputType.number,
    );
  }

  Widget quantityNeededWidget(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interMedium16(Strings.quantityNeeded.requiredSymbol(),
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
                          widget.medication.schedules[index].scheduledDosings
                              .first.qty,
                      orElse: () => widget.medication.schedules[index]
                          .scheduledDosings.first.qty),
                  onChanged: (double? value) {
                    setState(() {
                      widget.medication.schedules[index].scheduledDosings.first
                          .qty = value!;
                    });
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

  Widget intervalBetweenDosesWidget(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interMedium16(
              Strings.intervalBetweenDoses.requiredSymbol(),
              color: LiviThemes.colors.gray500),
          LiviThemes.spacing.heightSpacer8(),
          Row(
            children: [
              Expanded(
                child: LiviDropdownButton<IntervalBetweenDoses>(
                  isExpanded: true,
                  value: IntervalBetweenDoses.values.singleWhere(
                      (element) => element == intervalBetweenDoses,
                      orElse: () => intervalBetweenDoses),
                  onChanged: (IntervalBetweenDoses? value) {
                    setState(() {
                      intervalBetweenDoses = value!;
                    });
                  },
                  items: IntervalBetweenDoses.values
                      .map<DropdownMenuItem<IntervalBetweenDoses>>(
                          (IntervalBetweenDoses value) {
                    return DropdownMenuItem<IntervalBetweenDoses>(
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

  Widget divider() {
    return Container(
      width: 1,
      color: LiviThemes.colors.gray300,
    );
  }

  Widget startDateWidget(int index) {
    return LiviInputField(
      title: Strings.startDate.requiredSymbol(),
      focusNode: FocusNode(),
      onTap: () => showMaterialDatePicker(
          context: context,
          initialDate: now,
          firstDate: now,
          index: index,
          lastDate: DateTime(_foreverYear),
          isStartDate: true),
      readOnly: true,
      controller: _startDateController[index],
      prefix: Padding(
        padding: const EdgeInsets.all(16),
        child: LiviThemes.icons.calendarIcon(),
      ),
    );
  }

  Widget endDateWidget(int index) {
    return LiviInputField(
      title: Strings.endDate.requiredSymbol(),
      focusNode: FocusNode(),
      readOnly: true,
      onTap: () => showMaterialDatePicker(
        context: context,
        index: index,
        isStartDate: false,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(_foreverYear),
      ),
      controller: _endDateController[index],
      prefix: Padding(
        padding: const EdgeInsets.all(16),
        child: LiviThemes.icons.calendarIcon(),
      ),
    );
  }

  Widget remindMeBefore(int index) {
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
                          element == schedules[index].timeReminderBefore,
                      orElse: () => schedules[index].timeReminderBefore),
                  onChanged: (TimeReminderBefore? value) {
                    setState(() {
                      schedules[index].timeReminderBefore = value!;
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

  Widget remindMeLater(int index) {
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
                          element == schedules[index].timeReminderLater,
                      orElse: () => schedules[index].timeReminderLater),
                  onChanged: (TimeReminderLater? value) {
                    setState(() {
                      schedules[index].timeReminderLater = value!;
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
    required int index,
  }) async {
    final dateTime = await showDatePicker(
      context: context,
      cancelText: isStartDate ? Strings.now : Strings.forever,
      confirmText: Strings.apply,
      initialDate: isStartDate ? now : schedules[index].startDate,
      firstDate: isStartDate
          ? now
          : schedules[index]
              .startDate, //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(_foreverYear),
    );
    if (dateTime == null) {
      if (isStartDate) {
        schedules[index].startDate = now;
      } else {
        schedules[index].endDate = dateTime;
      }
    } else {
      if (isStartDate) {
        schedules[index].startDate = dateTime;
      } else {
        schedules[index].endDate = dateTime;
      }
    }
    setDate(index);
  }

  Widget frequencyWidget(ScheduleType frequency, int index, {int flex = 3}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {
          widget.medication.type = frequency;
          setState(() {});
        },
        child: Ink(
          height: double.maxFinite,
          decoration: BoxDecoration(
              color: widget.medication.type == frequency
                  ? LiviThemes.colors.gray200
                  : LiviThemes.colors.baseWhite),
          child: Align(
            child: LiviTextStyles.interBold14(frequency.description,
                color: widget.medication.type == frequency
                    ? LiviThemes.colors.baseBlack
                    : LiviThemes.colors.gray500),
          ),
        ),
      ),
    );
  }

  Widget daysWidget(int index) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interSemiBold14(Strings.days.requiredSymbol()),
          LiviThemes.spacing.heightSpacer16(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dayWidget(DateTime.sunday, index),
              dayWidget(DateTime.monday, index),
              dayWidget(DateTime.tuesday, index),
              dayWidget(DateTime.wednesday, index),
              dayWidget(DateTime.thursday, index),
              dayWidget(DateTime.friday, index),
              dayWidget(DateTime.saturday, index),
            ],
          ),
        ],
      ),
    );
  }

  Widget addAnotherScheduleWidget() {
    return SizedBox(
      child: LiviTextButton(
        margin: EdgeInsets.symmetric(horizontal: 64),
        text: Strings.addAnotherSchedule,
        onTap: () {
          //TODO: add schedule dose here
          schedules.add(
            Schedule(
              scheduledDosings: [
                ScheduledDose(
                  timeOfDay: TimeOfDay.now(),
                )
              ],
            ),
          );
          _startDateController.add(TextEditingController());
          _endDateController.add(TextEditingController());
          setDate(widget.medication.schedules.length - 1);
          setState(() {});
        },
        icon: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: LiviThemes.icons.plusIcon(),
        ),
      ),
    );
  }

  Widget dayWidget(int dayOfWeek, int index, {int flex = 1}) {
    return InkWell(
      onTap: () {
        if (schedules[index].dayPattern != null) {
          if (schedules[index].dayPattern!.contains(dayOfWeek)) {
            schedules[index].dayPattern!.remove(dayOfWeek);
          } else {
            schedules[index].dayPattern!.add(dayOfWeek);
          }
          setState(() {});
        }
      },
      child: Ink(
        height: (MediaQuery.of(context).size.width - 92) / 7,
        width: (MediaQuery.of(context).size.width - 92) / 7,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: schedules[index].dayPattern != null &&
                    schedules[index].dayPattern!.contains(dayOfWeek)
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
              color: schedules[index].dayPattern != null &&
                      schedules[index].dayPattern!.contains(dayOfWeek)
                  ? LiviThemes.colors.baseWhite
                  : dayOfWeek.isWeekend()
                      ? LiviThemes.colors.brand600
                      : LiviThemes.colors.baseBlack),
        ),
      ),
    );
  }

  Widget atWhatTimesWidget(int index) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interMedium16(Strings.atWhatTimes.requiredSymbol(),
              color: LiviThemes.colors.gray500),
          LiviThemes.spacing.heightSpacer8(),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: LiviDropdownButton<int>(
                  isExpanded: true,
                  value: hoursList.singleWhere((element) {
                    return element ==
                        convertTimeFormat(widget.medication.schedules[index]
                            .scheduledDosings.first.timeOfDay.hour);
                  }, orElse: () => hoursList.first),
                  onChanged: (int? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      widget.medication.schedules[index].scheduledDosings.first
                              .timeOfDay =
                          TimeOfDay(
                              hour: value!,
                              minute: widget.medication.schedules[index]
                                  .scheduledDosings.first.timeOfDay.minute);
                    });
                  },
                  items: hoursList.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              Spacer(),
              LiviTextStyles.interMedium16(':'),
              Spacer(),
              Expanded(
                flex: 7,
                child: LiviDropdownButton<int>(
                  isExpanded: true,
                  value: minutesList.singleWhere(
                      (element) =>
                          element ==
                          widget.medication.schedules[index].scheduledDosings
                              .first.timeOfDay.minute,
                      orElse: () => minutesList.first),
                  onChanged: (int? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      setState(() {
                        widget.medication.schedules[index].scheduledDosings
                                .first.timeOfDay =
                            TimeOfDay(
                                hour: widget.medication.schedules[index]
                                    .scheduledDosings.first.timeOfDay.hour,
                                minute: value!);
                      });
                    });
                  },
                  items: minutesList.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              Spacer(),
              LiviTextStyles.interMedium16(':'),
              Spacer(),
              Expanded(
                flex: 7,
                child: LiviDropdownButton<DayTime>(
                  isExpanded: true,
                  value: dayTime,
                  onChanged: (DayTime? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dayTime = value;
                      // dateTime.
                    });
                  },
                  items: DayTime.values
                      .map<DropdownMenuItem<DayTime>>((DayTime value) {
                    return DropdownMenuItem<DayTime>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
