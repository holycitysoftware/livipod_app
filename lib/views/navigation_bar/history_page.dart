import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/auth_controller.dart';
import '../../models/enums.dart';
import '../../models/medication_history.dart';
import '../../services/medication_service.dart';
import '../../themes/livi_themes.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
            backgroundColor: LiviThemes.colors.baseWhite,
            body: StreamBuilder<List<MedicationHistory>>(
                stream: getMedicationHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                        elevation: 10,
                        snap: true,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        floating: true,
                        title: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LiviTextStyles.interSemiBold36(Strings.history),
                              Row(
                                children: [
                                  LiviTextStyles.interRegular16(Strings.share,
                                      color: LiviThemes.colors.brand600),
                                  SizedBox(width: 4),
                                  LiviThemes.icons.shareIcon(
                                      color: LiviThemes.colors.brand600,
                                      height: 18),
                                ],
                              )
                            ],
                          ),
                        ),
                        // toolbarHeight: 200,
                        leadingWidth: 600,
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            daysFilter(),
                            NameCircleBox(
                              name: authController.appUser!.name,
                              profilePic:
                                  authController.appUser!.base64EncodedImage,
                            ),
                          ],
                        ),
                      ),
                      SliverList.separated(
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: LiviThemes.colors.baseBlack.withOpacity(.08),
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final medicationHistory = snapshot.data![index];

                          return ListTile(
                            minLeadingWidth: -20,
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
                              child: LiviTextStyles.interMedium16(
                                  medicationHistory.medicationName),
                            ),
                            trailing:
                                medicationHistory.scheduledDosingTime != null
                                    ? LiviTextStyles.interRegular14(
                                        formartTimeOfDay(
                                            TimeOfDay(
                                                hour: medicationHistory
                                                    .scheduledDosingTime!.hour,
                                                minute: medicationHistory
                                                    .scheduledDosingTime!
                                                    .minute),
                                            authController
                                                .appUser!.useMilitaryTime),
                                        color: LiviThemes.colors.gray500,
                                      )
                                    : null,
                            // subtitle: LiviTextStyles.interRegular14(),
                          );
                        },
                      ),
                    ],
                  );
                })),
      ),
    );
  }

  Widget daysFilter() {
    return Container(
      decoration: BoxDecoration(
        color: LiviThemes.colors.gray100,
        borderRadius: BorderRadius.circular(8),
      ),
      height: 90,
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
    return InkWell(
      onTap: () {
        setState(() {
          daysFilterValue = daysFilter;
        });
      },
      child: LiviTextStyles.interSemiBold14(
        daysFilter.description,
        color: daysFilter == daysFilterValue
            ? LiviThemes.colors.gray700
            : LiviThemes.colors.gray500,
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
