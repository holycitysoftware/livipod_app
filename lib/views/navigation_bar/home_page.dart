import 'dart:math';

import 'package:card_stack_widget/card_stack_widget.dart';
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

  CardStackWidget _buildCardStackWidget(BuildContext context) {
    final mockList = _buildMockList(context, size: 4);

    return CardStackWidget(
      opacityChangeOnDrag: true,
      swipeOrientation: CardOrientation.both,
      cardDismissOrientation: CardOrientation.both,
      positionFactor: 3,
      scaleFactor: 1.5,
      alignment: Alignment.center,
      reverseOrder: true,
      animateCardScale: true,
      dismissedCardDuration: const Duration(milliseconds: 150),
      cardList: _buildMockList(context, size: 4),
    );
  }

  List<CardModel> _buildMockList(BuildContext context, {int size = 0}) {
    final double containerWidth = MediaQuery.of(context).size.width - 16;

    var list = <CardModel>[];
    for (int i = 0; i < size; i++) {
      var color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
          .withOpacity(1.0);

      list.add(
        CardModel(
          backgroundColor: color,
          radius: Radius.circular(8),
          shadowColor: Colors.black.withOpacity(0.2),
          child: SizedBox(
            height: 310,
            width: containerWidth,
            child: Container(), // Whatever you want
          ),
        ),
      );
    }

    return list;
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
                    Medication? nextMed;
                    for (final element in snapshot.data!) {
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
                    if (nextMed.nextDosing!.scheduledDosingTime!.day !=
                            now.day &&
                        nextMed.nextDosing!.scheduledDosingTime!.month !=
                            now.month &&
                        nextMed.nextDosing!.scheduledDosingTime!.year !=
                            now.year) {
                      return LiviTextStyles.interRegular16(
                          '${Strings.nextMedsDueAt} ${DateFormat.jm().format(nextMed.nextDosing!.scheduledDosingTime!)}',
                          color: LiviThemes.colors.baseBlack);
                    } else {
                      return LiviTextStyles.interRegular16(
                          '${Strings.nextMedsDueAt} ${DateFormat.yMMMMd('en_US').format(nextMed.nextDosing!.scheduledDosingTime!)} ${DateFormat.jm().format(nextMed.nextDosing!.scheduledDosingTime!)}',
                          color: LiviThemes.colors.baseBlack);
                    }
                  },
                ),
                StreamBuilder<List<Medication>>(
                    stream: MedicationService()
                        .listenToMedicationsRealTime(authController.appUser!),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return SizedBox();
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final item = snapshot.data![index];
                            return Container(
                              decoration: BoxDecoration(
                                color: LiviThemes.colors.baseWhite,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: LiviThemes.colors.gray200,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    dosageFormIcon(dosageForm: item.dosageForm),
                                    LiviThemes.spacing.widthSpacer16(),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          LiviTextStyles.interSemiBold16(
                                            item.name,
                                          ),
                                          LiviTextStyles.interRegular14(
                                            item.getMedicationInfo(),
                                            color: LiviThemes.colors.gray700,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          for (final scheduleDescription
                                              in item.schedules)
                                            LiviTextStyles.interRegular14(
                                                scheduleDescription
                                                    .getScheduleDescription(),
                                                color:
                                                    LiviThemes.colors.brand600),
                                          Row(
                                            children: [
                                              LiviOutlinedButton(
                                                  onTap: () {},
                                                  text: Strings.skip),
                                              LiviOutlinedButton(
                                                  onTap: () {},
                                                  text: Strings.confirm)
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
