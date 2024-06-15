import 'package:flutter/material.dart';

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
  CardStackAnimation({
    super.key,
    required this.medications,
    required this.title,
    required this.buttons,
  });
  @override
  _CardStackAnimationState createState() => _CardStackAnimationState();
}

class _CardStackAnimationState extends State<CardStackAnimation>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  var cardHeight = 180.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    if (widget.medications.isNotEmpty &&
        widget.medications.first.schedules.first.type ==
            ScheduleType.asNeeded) {
      cardHeight = 175.0;
    }
  }

  Widget getPill(int index) {
    if (widget.medications[index].nextDosing == null ||
        widget.medications[index].nextDosing!.scheduledDosingTime == null ||
        widget.medications[index].isAsNeeded()) {
      return SizedBox();
    }
    final now = DateTime.now();
    if (widget.medications[index].isDue()) {
      return LiviPillInfoStyles.due();
    } else if (widget.medications[index].nextDosing!.scheduledDosingTime!
        .isTomorrow()) {
      return LiviPillInfoStyles.tomorrow();
    } else if (now.isAfter(
      widget.medications[index].nextDosing!.scheduledDosingTime!.add(
        Duration(minutes: 5),
      ),
    )) {
      return LiviPillInfoStyles.late();
    } else {
      return LiviPillInfoStyles.early();
    }
  }

  void _toggleExpanded() {
    isExpanded = !isExpanded;

    setState(() {
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double getTopMargin(int index) {
    if (index == 0) {
      return 0;
    } else if (index == 1) {
      return 16;
    } else {
      return index * 16;
    }
  }

  double getSideMargin(int index) {
    if (!isExpanded) {
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

  Widget _buildCard(int index) {
    return Container(
      height: cardHeight,
      margin: EdgeInsets.fromLTRB(
          getSideMargin(index), getTopMargin(index), getSideMargin(index), 0),
      child: GestureDetector(
        onTap: _toggleExpanded,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, cardHeight * index * (1 - _animation.value)),
              child: child,
            );
          },
          child: Opacity(
            opacity:
                isExpanded && index == widget.medications.length - 1 ? 0.5 : 1,
            child: Container(
              decoration: BoxDecoration(
                color: LiviThemes.colors.baseWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: LiviThemes.colors.gray200,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  getPill(index),
                  LiviThemes.spacing.heightSpacer12(),
                  Expanded(
                    child: Row(
                      children: [
                        if (widget.medications[index].dosageForm != null)
                          Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: LiviThemes.colors.brand50,
                              borderRadius: BorderRadius.circular(64),
                            ),
                            child: dosageFormIcon(
                                dosageForm:
                                    widget.medications[index].dosageForm),
                          ),
                        LiviThemes.spacing.widthSpacer16(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LiviTextStyles.interSemiBold16(
                                widget.medications[index].name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              LiviTextStyles.interRegular14(
                                widget.medications[index].getMedicationInfo(),
                                color: LiviThemes.colors.gray700,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              for (final scheduleDescription
                                  in widget.medications[index].schedules)
                                LiviTextStyles.interRegular14(
                                    scheduleDescription
                                        .getScheduleDescription(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    color: LiviThemes.colors.brand600),
                              Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.buttons(widget.medications, index),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> cards() {
    final List<Widget> list = [];
    if (isExpanded) {
      for (int i = widget.medications.length - 1; i > -1; i--) {
        list.add(_buildCard(i));
      }
    } else {
      for (int i = widget.medications.length - 1; i > -1; i--) {
        list.add(_buildCard(i));
      }
    }
    return list;
  }

  double getHeight() {
    if (widget.medications.length == 1) {
      return cardHeight + 50;
    } else {
      if (isExpanded) {
        return cardHeight + (20 * widget.medications.length);
      } else {
        return (cardHeight * widget.medications.length.toDouble()) +
            (20 * widget.medications.length);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.medications.isEmpty) {
      return SizedBox();
    }
    return SizedBox(
      height: getHeight(),
      child: Column(
        children: [
          Row(
            children: [
              LiviThemes.icons
                  .alarmClockIcon(color: LiviThemes.colors.gray600, height: 16),
              LiviThemes.spacing.widthSpacer4(),
              LiviTextStyles.interMedium12(widget.title,
                  color: LiviThemes.colors.gray600),
              Spacer(),
              if (widget.medications.isNotEmpty &&
                  widget.medications.length > 1)
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: LiviThemes.colors.baseWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: LiviThemes.colors.gray200,
                    ),
                  ),
                  child: InkWell(
                    onTap: _toggleExpanded,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isExpanded)
                          LiviThemes.icons
                              .chevronDownIcon(color: LiviThemes.colors.gray400)
                        else
                          LiviThemes.icons
                              .chevronUpIcon(color: LiviThemes.colors.gray400),
                        LiviThemes.spacing.widthSpacer8(),
                        if (widget.medications.isNotEmpty)
                          LiviTextStyles.interMedium12(
                            isExpanded ? Strings.expand : Strings.collapse,
                            color: LiviThemes.colors.gray700,
                          ),
                      ],
                    ),
                  ),
                ),
              LiviThemes.spacing.widthSpacer8(),
              if (widget.medications.isNotEmpty &&
                  widget.medications.length > 1)
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: LiviThemes.colors.baseWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: LiviThemes.colors.gray200,
                    ),
                  ),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LiviTextStyles.interMedium12(
                          Strings.takeAll,
                          color: LiviThemes.colors.gray700,
                        ),
                        LiviThemes.spacing.widthSpacer4(),
                        LiviThemes.icons
                            .checkIcon(color: LiviThemes.colors.gray400),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          LiviThemes.spacing.heightSpacer8(),
          SingleChildScrollView(
              child: Stack(alignment: Alignment.center, children: cards())),
        ],
      ),
    );
  }
}
