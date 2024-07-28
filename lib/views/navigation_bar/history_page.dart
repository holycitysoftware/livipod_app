import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../components/components.dart';
import '../../controllers/auth_controller.dart';
import '../../models/enums.dart';
import '../../models/medication_history.dart';
import '../../models/models.dart';
import '../../models/schedule_type.dart';
import '../../services/medication_service.dart';
import '../../themes/livi_themes.dart';
import '../../utils/string_ext.dart';
import '../../utils/strings.dart';
import '../../utils/utils.dart';
import '../views.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final AuthController authController;
  var daysFilterValue = DaysFilter.sevenDays;
  var historyList = <MedicationHistory>[];

  final dateFormat = DateFormat('EEEE, MMM d');
  int taken = 0;
  int missed = 0;
  int skipped = 0;

  @override
  void initState() {
    authController = Provider.of<AuthController>(context, listen: false);
    super.initState();
  }

  Future<void> goToSearchMedications({String? medication}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchMedicationPage(
          medication: medication,
        ),
      ),
    );
  }

  int calculateAdherence(List<MedicationHistory> list) {
    taken = 0;
    missed = 0;
    skipped = 0;
    for (final item in list) {
      if (item.scheduleType != ScheduleType.asNeeded) {
        if (item.outcome == DosingOutcome.missed) {
          missed++;
        } else if (item.outcome == DosingOutcome.skipped) {
          skipped++;
        } else if (item.outcome == DosingOutcome.taken) {
          taken++;
        }
      }
    }
    if (taken == 0) {
      return 0;
    }
    return (100 * taken / list.length).floor();
  }

  DateTime getStartDate() {
    if (daysFilterValue == DaysFilter.sevenDays) {
      return DateTime.now().subtract(Duration(days: 7));
    } else if (daysFilterValue == DaysFilter.thirtyDays) {
      return DateTime.now().subtract(Duration(days: 30));
    } else {
      return DateTime.now().subtract(Duration(days: 90));
    }
  }

  DateTime getEndDate() {
    return DateTime.now();
  }

  Stream<List<MedicationHistory>> getMedicationHistory() {
    final appUser = Provider.of<AuthController>(context).appUser;
    return MedicationService()
        .listenToHistoryRealTime(appUser!, getStartDate(), getEndDate());
  }

  Widget emptyPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: LiviTextStyles.interSemiBold36(Strings.history)),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: Column(
              children: [
                Spacer(),
                LiviTextStyles.interMedium20(Strings.noRecordedHistoryYet),
                SizedBox(height: 16),
                LiviTextStyles.interRegular16(Strings.addMedicationsSoThat,
                    color: LiviThemes.colors.gray600,
                    textAlign: TextAlign.center),
                SizedBox(height: 12),
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(4),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  alignment: Alignment.center,
                  child: InkWell(
                    radius: 12,
                    borderRadius: BorderRadius.circular(12),
                    onTap: goToSearchMedications,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LiviThemes.icons.alarmAddIcon(
                              color: LiviThemes.colors.brand600, height: 20),
                          SizedBox(width: 8),
                          LiviTextStyles.interMedium16(Strings.addMedication,
                              color: LiviThemes.colors.brand600),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  shareHistory() {}

  @override
  Widget build(BuildContext context) {
    print('build');
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: LiviThemes.colors.baseWhite,
          body: StreamBuilder<List<MedicationHistory>>(
            stream: getMedicationHistory(),
            builder: (context, snapshot) {
              print('stream');
              if (snapshot.hasData) {
                historyList = snapshot.data!;
              }
              if (snapshot.connectionState == ConnectionState.waiting &&
                  historyList.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 64),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.data == null ||
                  (snapshot.data != null && snapshot.data!.isEmpty)) {
                print('snapshot.data: ${snapshot.data}');
                return emptyPage();
              }
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    elevation: 40,
                    snap: true,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    floating: true,
                    title: Container(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LiviTextStyles.interSemiBold36(Strings.history),
                          InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: shareHistory,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: Row(
                                children: [
                                  LiviTextStyles.interRegular16(Strings.share,
                                      color: LiviThemes.colors.brand600),
                                  SizedBox(width: 4),
                                  LiviThemes.icons.shareIcon(
                                      color: LiviThemes.colors.brand600,
                                      height: 18),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // toolbarHeight: 200,
                    toolbarHeight: 80,
                    leadingWidth: 600,
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              LiviThemes.icons
                                  .graphIcon(color: LiviThemes.colors.gray500),
                              SizedBox(width: 8),
                              LiviTextStyles.interSemiBold16(
                                  Strings.complianceRate,
                                  color: LiviThemes.colors.gray700),
                            ],
                          ),
                        ),
                        daysFilter(),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            NameCircleBox(
                              name: authController.appUser!.name,
                              profilePic:
                                  authController.appUser!.base64EncodedImage,
                            ),
                            Column(
                              children: [
                                LiviTextStyles.interRegular14(Strings.adherence,
                                    color: LiviThemes.colors.gray500),
                                LiviTextStyles.interBold36(
                                    '${calculateAdherence(snapshot.data!)}%'),
                              ],
                            ),
                            Column(
                              children: [
                                LiviTextStyles.interRegular14(Strings.scheduled,
                                    color: LiviThemes.colors.gray500),
                                LiviTextStyles.interBold36(
                                    '$taken/${snapshot.data!.length}'),
                              ],
                            ),
                            SizedBox(width: 1),
                          ],
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              statusDescription(
                                title: Strings.taken,
                                number: taken,
                                icon: LiviThemes.icons.checkCircleFilledIcon(
                                    color: LiviThemes.colors.success600,
                                    height: 28),
                              ),
                              dividerHistory(),
                              statusDescription(
                                  title: Strings.skipped,
                                  number: skipped,
                                  icon: LiviThemes.icons.skipForwardIcon(
                                      color: LiviThemes.colors.warning500,
                                      height: 28)),
                              dividerHistory(),
                              statusDescription(
                                  title: Strings.missed,
                                  number: missed,
                                  icon: LiviThemes.icons.alarmClockOffIcon(
                                      color: LiviThemes.colors.error500,
                                      height: 28)),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        Divider(
                          height: 1,
                          color: LiviThemes.colors.baseBlack.withOpacity(.08),
                        ),
                        // Text(),
                      ],
                    ),
                  ),
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      historyList.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 64),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  else
                    historyListWidget(snapshot),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget historyListWidget(AsyncSnapshot<List<MedicationHistory>> snapshot) {
    final List<HistoryDay> historyDays = [];
    for (final element in snapshot.data!) {
      if (historyDays.isEmpty) {
        historyDays.add(HistoryDay(
          date: DateTime(element.dateTime.year, element.dateTime.month,
              element.dateTime.day),
          taken: [],
          missed: [],
          skipped: [],
        ));
      } else if (!element.dateTime.isSameDayMonthYear(historyDays.last.date)) {
        historyDays.add(HistoryDay(
          date: DateTime(element.dateTime.year, element.dateTime.month,
              element.dateTime.day),
          taken: [],
          missed: [],
          skipped: [],
        ));
      }
      if (element.outcome == DosingOutcome.taken) {
        historyDays.last.taken.add(element);
      } else if (element.outcome == DosingOutcome.missed ||
          element.outcome == DosingOutcome.jam) {
        historyDays.last.missed.add(element);
      } else {
        historyDays.last.skipped.add(element);
      }
    }
    return SliverList.list(
      children: listBuilder(context, historyDays),
    );
  }

  Widget statusDescription(
      {required String title, required int number, required Widget icon}) {
    return Row(
      children: [
        icon,
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LiviTextStyles.interMedium18(number.toString()),
            LiviTextStyles.interRegular14(title,
                color: LiviThemes.colors.gray500),
          ],
        ),
      ],
    );
  }

  Widget dividerHistory() {
    return Container(
      width: 1,
      height: 28,
      color: LiviThemes.colors.gray200,
    );
  }

  int calculateListLength(List<HistoryDay> list) {
    var length = 0;
    for (final item in list) {
      length++;
      if (item.taken.isNotEmpty) {
        length += item.taken.length + 1;
      }
      if (item.missed.isNotEmpty) {
        length += item.missed.length + 1;
      }
      if (item.skipped.isNotEmpty) {
        length += item.skipped.length + 1;
      }
    }
    return length;
  }

  List<Widget> listBuilder(BuildContext context, List<HistoryDay> list) {
    var widgetsList = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      widgetsList.add(Padding(
        padding: const EdgeInsets.all(16),
        child: LiviTextStyles.interMedium16(dateFormat.format(list[i].date),
            color: LiviThemes.colors.baseBlack),
      ));
      if (list[i].taken.isNotEmpty) {
        widgetsList.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: LiviTextStyles.interMedium14(
                '${Strings.taken} (${list[i].taken.length})',
                color: LiviThemes.colors.gray600),
          ),
        );
        widgetsList.addAll(list[i].taken.map((e) {
          if (e == list[i].taken.first) {
            return medicationHistoryCard(e, divider: false);
          }
          return medicationHistoryCard(e);
        }).toList());
      }
      if (list[i].skipped.isNotEmpty) {
        widgetsList.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: LiviTextStyles.interMedium14(
                '${Strings.skipped} (${list[i].skipped.length})',
                color: LiviThemes.colors.gray600),
          ),
        );
        widgetsList.addAll(list[i].skipped.map((e) {
          print(e.dateTime.toString());
          if (e == list[i].skipped.first) {
            return medicationHistoryCard(e, divider: false);
          }
          return medicationHistoryCard(e);
        }).toList());
      }
      if (list[i].missed.isNotEmpty) {
        widgetsList.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: LiviTextStyles.interMedium14(
                '${Strings.missed} (${list[i].missed.length})',
                color: LiviThemes.colors.gray600),
          ),
        );
        widgetsList.addAll(list[i].missed.map((e) {
          if (e == list[i].missed.first) {
            return medicationHistoryCard(e, divider: false);
          }
          return medicationHistoryCard(e);
        }).toList());
      }
    }
    return widgetsList;
  }

  Widget medicationHistoryCard(MedicationHistory history, {bool? divider}) {
    return Column(
      children: [
        if (divider != false)
          Divider(
            height: 1,
            color: LiviThemes.colors.baseBlack.withOpacity(.08),
          ),
        ListTile(
          contentPadding: EdgeInsets.all(12),
          leading: Container(
            padding: EdgeInsets.all(12),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: LiviThemes.colors.gray200,
              shape: BoxShape.circle,
            ),
            child: dosageFormIcon(
                dosageForm: DosageForm.aerosol_spray,
                color: LiviThemes.colors.gray700),
          ),
          title: Container(
            child: LiviTextStyles.interMedium16(history.medicationName),
          ),
          trailing: history.scheduledDosingTime != null
              ? LiviTextStyles.interRegular14(
                  formartTimeOfDay(
                      TimeOfDay(
                          hour: history.scheduledDosingTime!.hour,
                          minute: history.scheduledDosingTime!.minute),
                      authController.appUser!.useMilitaryTime),
                  color: LiviThemes.colors.gray500,
                )
              : null,
          // subtitle: LiviTextStyles.interRegular14(),
        ),
      ],
    );
  }

  Widget daysFilter() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LiviThemes.colors.gray100,
        borderRadius: BorderRadius.circular(8),
      ),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          textDaysFiter(DaysFilter.sevenDays),
          textDaysFiter(DaysFilter.thirtyDays),
          textDaysFiter(DaysFilter.ninetyDays),
        ],
      ),
    );
  }

  Widget textDaysFiter(DaysFilter daysFilter) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: LiviThemes.colors.gray100)),
      alignment: Alignment.center,
      margin: EdgeInsets.all(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            daysFilterValue = daysFilter;
          });
        },
        child: Ink(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: daysFilterValue == daysFilter
                ? LiviThemes.colors.baseWhite
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: LiviThemes.colors.gray100,
            elevation: daysFilterValue == daysFilter ? 2 : 0,
            child: LiviTextStyles.interSemiBold14(
              daysFilter.description,
              color: daysFilter == daysFilterValue
                  ? LiviThemes.colors.gray700
                  : LiviThemes.colors.gray500,
            ),
          ),
        ),
      ),
    );
  }
}

enum DaysFilter {
  sevenDays(description: '07 days'),
  thirtyDays(description: '30 days'),
  ninetyDays(description: '90 days');

  const DaysFilter({
    required this.description,
  });

  final String description;
}

class HistoryDay {
  final DateTime date;
  final List<MedicationHistory> taken;
  final List<MedicationHistory> missed;
  final List<MedicationHistory> skipped;

  HistoryDay(
      {required this.date,
      required this.taken,
      required this.missed,
      required this.skipped});
}
