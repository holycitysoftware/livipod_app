import 'dart:math';

import 'package:card_stack_widget/card_stack_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../controllers/auth_controller.dart';
import '../../models/enums.dart';
import '../../models/models.dart';
import '../../services/medication_service.dart';
import '../../themes/livi_themes.dart';
import '../../utils/string_ext.dart';
import '../../utils/strings.dart';
import '../../utils/utils.dart';

///Route: home-page
class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final now = DateTime.now();

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
    medications.forEach(
      (element) {
        if (element.nextDosing!.outcome == DosingOutcome.missed) {
          lateMedications = true;
        }
      },
    );
    if (lateMedications) {
      return LiviTextStyles.interRegular16(Strings.youHaveLateMedicines,
          color: LiviThemes.colors.baseBlack);
    }
    for (final element in medications) {
      if (element.nextDosing != null) {
        final date = element.nextDosing!.scheduledDosingTime;
      }
      if (nextMed == null) {
        nextMed = element;
      } else if (element.nextDosing!.scheduledDosingTime!
          .isBefore(nextMed.nextDosing!.scheduledDosingTime!)) {
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

  @override
  Widget build(BuildContext context) {
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
            child: ListView(
              padding: const EdgeInsets.all(24.0),
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
                StreamBuilder<List<Medication>>(
                  stream: MedicationService()
                      .listenToMedicationsRealTime(authController.appUser!),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return SizedBox();
                    }
                    return descriptionNextMeds(snapshot.data!);
                  },
                ),
                // Column(
                //   children: [
                //     Container(
                //       color: Colors.red,
                //       height: 90,
                //     ),
                //     Container(
                //       color: Colors.red,
                //       height: 90,
                //     ),
                //     Container(
                //       color: Colors.red,
                //       height: 90,
                //     ),
                //     Container(
                //       color: Colors.black,
                //       height: 90,
                //     ),
                //     Container(
                //       color: Colors.black,
                //       height: 90,
                //     ),
                //     Container(
                //       color: Colors.red,
                //       height: 90,
                //     ),
                //     Container(
                //       color: Colors.red,
                //       height: 90,
                //     ),
                //     Container(
                //       color: Colors.black,
                //       height: 90,
                //     ),
                //   ],
                // ),
                LiviThemes.spacing.heightSpacer16(),
                StreamBuilder<List<Medication>>(
                    stream: MedicationService()
                        .listenToMedicationsRealTime(authController.appUser!),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return SizedBox();
                      }
                      var list = snapshot.data!.where((element) {
                        return element.nextDosing != null &&
                            element.nextDosing!.outcome == DosingOutcome.missed;
                      }).toList();
                      return CardStackScreen(medications: snapshot.data!);
                    }),
                StreamBuilder<List<Medication>>(
                    stream: MedicationService()
                        .listenToMedicationsRealTime(authController.appUser!),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return SizedBox();
                      }
                      var list = snapshot.data!.where((element) {
                        return element.nextDosing != null &&
                            element.nextDosing!.outcome == DosingOutcome.missed;
                      }).toList();
                      return CardStackScreen(medications: snapshot.data!);
                    })
              ],
            ),
          );
        }),
      ),
    );
  }
}

class CardStackScreen extends StatefulWidget {
  final List<Medication> medications;
  CardStackScreen({super.key, required this.medications});
  @override
  _CardStackScreenState createState() => _CardStackScreenState();
}

class _CardStackScreenState extends State<CardStackScreen>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  final cardHeight = 150.0;
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
  }

  void _toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
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
          child: Container(
            decoration: BoxDecoration(
              color: LiviThemes.colors.baseWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: LiviThemes.colors.gray200,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
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
                                    color: LiviThemes.colors.brand600),
                              Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LiviOutlinedButton(
                            onTap: () {
                              print('here');
                            },
                            text: Strings.skip),
                      ),
                      LiviThemes.spacing.widthSpacer8(),
                      Expanded(
                        child: LiviOutlinedButton(
                            onTap: () {
                              print('here');
                            },
                            text: Strings.confirm),
                      )
                    ],
                  ),
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.maxFinite,
      child: Column(
        children: [
          Row(
            children: [
              LiviTextStyles.interMedium12(Strings.medsDue.toUpperCase(),
                  color: LiviThemes.colors.gray600),
              Spacer(),
              // if( )
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      LiviThemes.spacing.widthSpacer8(),
                      LiviThemes.icons
                          .checkIcon(color: LiviThemes.colors.gray400),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            child: Stack(alignment: Alignment.center, children: cards()),
          ),
        ],
      ),
    );
  }
}
