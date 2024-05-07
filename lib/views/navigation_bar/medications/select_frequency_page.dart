import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../components/components.dart';
import '../../../models/enums.dart';
import '../../../models/models.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/string_ext.dart';
import '../../../utils/strings.dart';
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
  Frequency selectedFrequency = Frequency.asNeeded;
  List<DayOfWeek> selectedDaysOfWeek = [];
  DateTime now = DateTime.now();
  DateTime atWhatTimeDate = DateTime.now();
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime(_foreverYear);
  List<int> hoursList = List.generate(13, (index) => index++);
  List<int> minutesList = List.generate(60, (index) => index++);
  DayTime? dayTime = DayTime.am;
  final dateFormat = DateFormat.yMMMMd('en_US');

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _quantityNeededController =
      TextEditingController();
  final FocusNode _quantityNeededFoucs = FocusNode();
  @override
  void initState() {
    dayTime = now.hour > 12 ? DayTime.pm : DayTime.am;
    atWhatTimeDate = now;
    startDateTime = now;
    endDateTime = DateTime(_foreverYear);
    setDate();
    // dateTime = now;
    super.initState();
  }

  int convertTimeFormat(int hour) {
    if (hour > 11) {
      return hour - 12;
    }
    return hour;
  }

  void setDate() {
    if (startDateTime.isSameDayMonthYear(now)) {
      _startDateController.text = Strings.now;
    } else {
      _startDateController.text = dateFormat.format(startDateTime);
    }
    if (endDateTime.year == _foreverYear) {
      _endDateController.text = Strings.forever;
    } else {
      _endDateController.text = dateFormat.format(endDateTime);
    }
  }

  // bool get showInventoryQuantityField =>
  //     (widget.medication.dosageForm == DosageForm.tablet ||
  //         widget.medication.dosageForm == DosageForm.capsule) &&
  //     (selectedFrequency.isDaily() ||
  //         selectedFrequency.isWeekly() ||
  //         selectedFrequency.isMonthly() ||
  //         selectedFrequency.isAsNeeded());

  // bool get showQuantityNeededField => selectedFrequency.isAsNeeded();
  // bool get showQuantityField => selectedFrequency.isDaily();
  bool get isEnabled => true;

  bool isForever(DateTime date) => date.year == _foreverYear;

  void goToHomePage() {
    Navigator.popUntil(
      context,
      (route) => route.settings.name == SmsFlowPage.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: LiviFilledButton(
          isCloseToNotch: true,
          showArrow: true,
          text: Strings.continueText,
          onTap: () {},
        ),
      ),
      appBar: LiviAppBar(
        ///TODO: we need to see all the required fields
        ///and check if all THE REQUIREDS fields are filled :)
        title: widget.medication.name,
        onPressed: () {},
        tail: [
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
        ],
      ),
      body: ListView(
        children: [
          LiviThemes.spacing.heightSpacer32(),
          Container(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                frequencyWidget(Frequency.asNeeded, flex: 4),
                divider(),
                frequencyWidget(Frequency.daily),
                divider(),
                frequencyWidget(Frequency.weekly),
                divider(),
                frequencyWidget(Frequency.monthly),
              ],
            ),
          ),
          LiviInputField(
            title: Strings.inventoryQuantity.requiredSymbol(),
            focusNode: _quantityNeededFoucs,
            controller: _quantityNeededController,
            keyboardType: TextInputType.number,
          ),
          LiviInputField(
            title: Strings.startDate.requiredSymbol(),
            focusNode: FocusNode(),
            onTap: () => showMaterialDatePicker(
                context: context,
                initialDate: now,
                firstDate: now,
                lastDate: endDateTime,
                isStartDate: true),
            readOnly: true,
            controller: _startDateController,
            prefix: Padding(
              padding: const EdgeInsets.all(16),
              child: LiviThemes.icons.calendarIcon(),
            ),
          ),
          LiviInputField(
            title: Strings.endDate.requiredSymbol(),
            focusNode: FocusNode(),
            readOnly: true,
            onTap: () => showMaterialDatePicker(
              context: context,
              isStartDate: false,
              initialDate: now,
              firstDate: now,
              lastDate: endDateTime,
            ),
            controller: _endDateController,
            prefix: Padding(
              padding: const EdgeInsets.all(16),
              child: LiviThemes.icons.calendarIcon(),
            ),
          ),
          atWhatTimesWidget(),
          daysWidget(),
          SizedBox(
            child: LiviTextButton(
              margin: EdgeInsets.symmetric(horizontal: 64),
              text: Strings.addAnotherSchedule,
              onTap: () {},
              icon: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: LiviThemes.icons.plusIcon(),
              ),
            ),
          )
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

//TODO block end date bvy intial date
  Future<void> showMaterialDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required bool isStartDate,
  }) async {
    final dateTime = await showDatePicker(
          context: context,
          // controller: controller,
          // date: dateTime,_

          //  LiviThemes.colors.brand600,

          cancelText: isStartDate ? Strings.now : Strings.forever,
          confirmText: Strings.apply,
          initialDate: now,
          firstDate:
              now, //DateTime.now() - not to allow to choose before today.
          lastDate: endDateTime,
        ) ??
        now;
    if (isStartDate) {
      startDateTime = dateTime;
    } else {
      endDateTime = dateTime;
    }
    setDate();
  }

  Widget frequencyWidget(Frequency frequency, {int flex = 3}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedFrequency = frequency;
          });
        },
        child: Ink(
          height: double.maxFinite,
          decoration: BoxDecoration(
              color: selectedFrequency == frequency
                  ? LiviThemes.colors.gray200
                  : LiviThemes.colors.baseWhite),
          child: Align(
            child: LiviTextStyles.interBold14(frequency.description,
                color: selectedFrequency == frequency
                    ? LiviThemes.colors.baseBlack
                    : LiviThemes.colors.gray500),
          ),
        ),
      ),
    );
  }

  Widget daysWidget() {
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
              dayWidget(DayOfWeek.sunday),
              dayWidget(DayOfWeek.monday),
              dayWidget(DayOfWeek.tuesday),
              dayWidget(DayOfWeek.wednesday),
              dayWidget(DayOfWeek.thursday),
              dayWidget(DayOfWeek.friday),
              dayWidget(DayOfWeek.saturday),
            ],
          ),
        ],
      ),
    );
  }

  Widget dayWidget(DayOfWeek dayOfWeek, {int flex = 1}) {
    return InkWell(
      onTap: () {
        if (selectedDaysOfWeek.contains(dayOfWeek)) {
          selectedDaysOfWeek.remove(dayOfWeek);
        } else {
          selectedDaysOfWeek.add(dayOfWeek);
        }
        setState(() {});
      },
      child: Ink(
        height: (MediaQuery.of(context).size.width - 92) / 7,
        width: (MediaQuery.of(context).size.width - 92) / 7,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: selectedDaysOfWeek.contains(dayOfWeek)
                ? LiviThemes.colors.brand600
                : dayOfWeek.isWeekend
                    ? LiviThemes.colors.brand50
                    : LiviThemes.colors.baseWhite,
            border: Border.all(
                color: LiviThemes.colors.gray300,
                width: dayOfWeek.isWeekend ? 0 : 1)),
        child: Align(
          child: LiviTextStyles.interRegular16(
              dayOfWeek.description.getFirstLetter(),
              color: selectedDaysOfWeek.contains(dayOfWeek)
                  ? LiviThemes.colors.baseWhite
                  : dayOfWeek.isWeekend
                      ? LiviThemes.colors.brand600
                      : LiviThemes.colors.baseBlack),
        ),
      ),
    );
  }

  Widget atWhatTimesWidget() {
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
                  value: hoursList.singleWhere((element) {
                    return element == convertTimeFormat(atWhatTimeDate.hour);
                  }, orElse: () => hoursList.first),
                  onChanged: (int? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      atWhatTimeDate = DateTime(
                          atWhatTimeDate.year,
                          atWhatTimeDate.month,
                          atWhatTimeDate.day,
                          value!,
                          atWhatTimeDate.minute);
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
                  value: minutesList.singleWhere(
                      (element) => element == atWhatTimeDate.minute,
                      orElse: () => minutesList.first),
                  onChanged: (int? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      atWhatTimeDate = DateTime(
                          atWhatTimeDate.year,
                          atWhatTimeDate.month,
                          atWhatTimeDate.day,
                          atWhatTimeDate.hour,
                          value!);
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
              Expanded(
                flex: 9,
                child: InkWell(
                  onTap: () {
                    setState(() {});
                  },
                  radius: 8,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: LiviThemes.colors.brand600,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: LiviThemes.colors.gray300),
                    ),
                    height: (MediaQuery.of(context).size.width - 92) / 7,
                    width: (MediaQuery.of(context).size.width - 92) / 7,
                    child: Align(
                      child: LiviThemes.icons
                          .plusIcon(color: LiviThemes.colors.baseWhite),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
