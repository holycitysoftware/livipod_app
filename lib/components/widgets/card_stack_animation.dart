import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/models.dart';
import '../../models/schedule_type.dart';
import '../../themes/livi_themes.dart';
import '../../utils/string_ext.dart';
import '../../utils/strings.dart';
import '../../utils/utils.dart';
import '../components.dart';

class CardStackAnimation extends StatefulWidget {
  final String title;
  final List<Medication> medications;
  final Widget Function(List<Medication>, int?) buttons;
  final Function() takeAllFunction;
  const CardStackAnimation({
    super.key,
    required this.medications,
    required this.title,
    required this.buttons,
    required this.takeAllFunction,
  });
  @override
  _CardStackAnimationState createState() => _CardStackAnimationState();
}

class _CardStackAnimationState extends State<CardStackAnimation>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  var cardHeight = 182.0;

  @override
  void initState() {
    if (widget.medications.isNotEmpty &&
        widget.medications.first.schedules.first.type ==
            ScheduleType.asNeeded) {
      cardHeight = 160;
    }
    super.initState();
  }

  // Schedule iterateOverSchedules(List<Schedule> schedules) {
  //   final now = DateTime.now();
  //   for (var schedule in schedules) {
  //     if (schedule.) {
  //       return schedule;
  //     }
  //   }
  //   return schedules.first;
  // }

  Widget getPill(int index) {
    if (widget.medications[index].nextDosing == null ||
        widget.medications[index].nextDosing!.scheduledDosingTime == null ||
        widget.medications[index].isAsNeeded()) {
      return SizedBox();
    }

    if (widget.medications[index].isAvailable()) {
      return LiviPillInfoStyles.available();
    } else if (widget.medications[index].isDue()) {
      return LiviPillInfoStyles.due();
    } else if (widget.medications[index].isLate()) {
      return LiviPillInfoStyles.late();
    } else {
      return SizedBox();
    }
  }

  double getTopMargin(int index) {
    if (index == 0) {
      return 0;
    } else if (index == 1) {
      return 8;
    } else {
      return index * 8;
    }
  }

  double getSideMargin(int index) {
    if (!_isExpanded) {
      return 0;
    }
    if (index == 0) {
      return 0;
    } else if (index == 1) {
      return 8;
    } else {
      return index * 8;
    }
  }

  void _toggleExpandCollapse() {
    if (widget.medications.length == 1) {
      return;
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  double getHeight() {
    if (widget.medications.length == 1) {
      return cardHeight + 50;
    } else {
      if (_isExpanded) {
        return cardHeight + (20 * widget.medications.length) + 20;
      } else {
        return (cardHeight * widget.medications.length.toDouble()) +
            (20 * widget.medications.length) +
            20;
      }
    }
  }

  List<Widget> cards() {
    final List<Widget> list = [];
    for (int i = widget.medications.length - 1; i > -1; i--) {
      list.add(
        _buildCard(i),
      );
    }
    return list;
  }

  Widget _buildCard(int index) {
    print('_buildCard ');
    const double initialTop = 20.0; // Initial top position for the first card
    final double expandedTop =
        20.0 + index * cardHeight; // Top position for expanded cards
    const double collapsedTop =
        initialTop; // All collapsed cards have the same top position

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: !_isExpanded ? expandedTop : collapsedTop,
      left: 0,
      right: 0,
      child: _buildCardUI(index),
    );
  }

  double cardOpacity(int index) {
    return _isExpanded && index == widget.medications.length - 1 ? 0.5 : 1;
  }

  Widget _buildCardUI(int index) {
    return HomePageCard(
      margin: EdgeInsets.only(
        top: getTopMargin(index),
        left: getSideMargin(index),
        right: getSideMargin(index),
      ),
      cardHeight: cardHeight,
      onTap: _toggleExpandCollapse,
      opacity: cardOpacity(index),
      pillIcon: getPill(index),
      buttons: widget.buttons(widget.medications, index),
      showDosageForm: true,
      dosageForm: widget.medications[index].dosageForm,
      name: widget.medications[index].name,
      medInfo: widget.medications[index].getMedicationInfo(),
      schedules: widget.medications[index].schedules,
    );
  }

  Widget title() {
    return Row(
      children: [
        LiviThemes.icons
            .alarmClockIcon(color: LiviThemes.colors.gray600, height: 16),
        LiviThemes.spacing.widthSpacer4(),
        LiviTextStyles.interMedium12(
          widget.title,
          color: LiviThemes.colors.gray600,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('CardStackAnimation build');
    if (widget.medications.isEmpty) {
      return SizedBox();
    } else if (widget.medications.length == 1) {
      return Column(
        children: [
          Row(
            children: [
              title(),
              Spacer(),
            ],
          ),
          LiviThemes.spacing.heightSpacer8(),
          Container(
            height: cardHeight,
            margin: EdgeInsets.only(bottom: 24),
            child: _buildCardUI(0),
          )
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              title(),
              Spacer(),
              TextIconHomeButton(
                  onTap: _toggleExpandCollapse,
                  isExpanded: _isExpanded,
                  children: [
                    if (_isExpanded)
                      LiviThemes.icons
                          .chevronDownIcon(color: LiviThemes.colors.gray400)
                    else
                      LiviThemes.icons
                          .chevronUpIcon(color: LiviThemes.colors.gray400),
                    LiviTextStyles.interMedium12(
                      _isExpanded ? Strings.expand : Strings.collapse,
                      color: LiviThemes.colors.gray700,
                    ),
                  ]),
              LiviThemes.spacing.widthSpacer6(),
              TextIconHomeButton(
                  onTap: widget.takeAllFunction,
                  isExpanded: _isExpanded,
                  children: [
                    LiviTextStyles.interMedium12(
                      Strings.takeAll,
                      color: LiviThemes.colors.gray700,
                    ),
                    LiviThemes.icons
                        .checkIcon(color: LiviThemes.colors.gray400),
                  ]),
            ],
          ),
          SizedBox(
            height: getHeight(),
            child: Stack(
              children: cards(),
            ),
          )
        ],
      );
    }
  }
}
