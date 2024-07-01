import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/models.dart';
import '../../models/schedule_type.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class CardStackAnimation extends StatefulWidget {
  final String title;
  final List<Medication> medications;
  final Widget Function(List<Medication>, int?) buttons;
  final Function()? takeAllFunction;
  const CardStackAnimation({
    super.key,
    required this.medications,
    required this.title,
    required this.buttons,
    this.takeAllFunction,
  });
  @override
  _CardStackAnimationState createState() => _CardStackAnimationState();
}

class _CardStackAnimationState extends State<CardStackAnimation>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  var cardHeight = 184.0;

  void setCardHeight(double textFactor14, double textFactor16) {
    final double textFactor =
        ((textFactor14 + textFactor14 + textFactor16) / 3) * .082;
    cardHeight = 184 * textFactor;
    if (widget.medications.isNotEmpty &&
        widget.medications.first.schedules.first.type ==
            ScheduleType.asNeeded) {
      cardHeight = 150 * textFactor;
    }
    if (cardHeight > 200) {
      cardHeight = cardHeight * .85;
    }
  }

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
    final List<Widget> cardsList = [];
    for (int i = widget.medications.length - 1; i > -1; i--) {
      if (widget.medications[0].lastDosing != null &&
          widget.medications[0].nextDosing != null &&
          widget.medications[0].lastDosing!.dosingId ==
              widget.medications[0].nextDosing!.dosingId) {
        SizedBox();
      } else {
        cardsList.add(
          _buildCard(i),
        );
      }
    }
    return cardsList;
  }

  Widget _buildCard(int index) {
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
    final isOnlyOneCard = widget.medications.length == 1;
    return (_isExpanded && index == widget.medications.length - 1) &&
            !isOnlyOneCard
        ? 0.5
        : 1;
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
      schedule: widget.medications[index].getCurrentSchedule(),
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
    setCardHeight(MediaQuery.of(context).textScaler.scale(14),
        MediaQuery.of(context).textScaler.scale(16));
    final cardsList = cards();
    if (widget.medications.isEmpty) {
      return SizedBox();
    } else if (widget.medications.length == 1) {
      if (widget.medications[0].lastDosing != null &&
          widget.medications[0].nextDosing != null &&
          widget.medications[0].lastDosing!.dosingId ==
              widget.medications[0].nextDosing!.dosingId) {
        return SizedBox();
      } else {
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
      }
    } else if (cardsList.isNotEmpty) {
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
              if (widget.takeAllFunction != null)
                LiviThemes.spacing.widthSpacer6(),
              if (widget.takeAllFunction != null)
                TextIconHomeButton(
                    onTap: widget.takeAllFunction!,
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
              children: cardsList,
            ),
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
