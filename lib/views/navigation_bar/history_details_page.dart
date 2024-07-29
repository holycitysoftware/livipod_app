import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/components.dart';
import '../../controllers/auth_controller.dart';
import '../../models/enums.dart';
import '../../models/medication_history.dart';
import '../../services/medication_service.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../../utils/utils.dart';

final _dateFormat = DateFormat('E, MMM d - ');

class HistoryDetailsPage extends StatelessWidget {
  final MedicationHistory medicationHistory;

  const HistoryDetailsPage({super.key, required this.medicationHistory});

  String getDateTime(BuildContext context) {
    return _dateFormat.format(medicationHistory.dateTime) +
        formartTimeOfDay(
            TimeOfDay(
              hour: medicationHistory.dateTime.hour,
              minute: medicationHistory.dateTime.minute,
            ),
            Provider.of<AuthController>(context, listen: false)
                .appUser!
                .useMilitaryTime);
  }

  takeMedication(BuildContext context, MedicationHistory medicationHistory) {
    medicationHistory.isOverride = true;
    // MedicationService().updateMedication(medicationHistory);
  }

  void dispenseFromPod(BuildContext context) {
    //TODO: dispense from pod
    print('Dispense from POD');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiviAppBar(
        title: Strings.overrideDose,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: LiviTextStyles.interMedium16(
                  Strings.areYouSureYouHaveTakeThisDose,
                  color: LiviThemes.colors.baseBlack,
                  textAlign: TextAlign.center),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(16),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: LiviThemes.colors.gray200,
                shape: BoxShape.circle,
              ),
              child: dosageFormIcon(
                  dosageForm:
                      medicationHistory.dosageForm ?? DosageForm.aerosol_spray,
                  color: LiviThemes.colors.gray700),
            ),
            Spacer(),
            LiviTextStyles.interMedium16(getDateTime(context),
                color: LiviThemes.colors.gray500),
            LiviTextStyles.interSemiBold20(medicationHistory.medicationName,
                color: LiviThemes.colors.gray500),
            if (medicationHistory.dosageForm != null)
              LiviTextStyles.interRegular16(
                  '${medicationHistory.dosageForm!.description}, ${medicationHistory.strength}',
                  color: LiviThemes.colors.gray500),
            Spacer(flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    InkWell(
                      radius: 80,
                      borderRadius: BorderRadius.circular(80),
                      onTap: () => takeMedication(context, medicationHistory),
                      child: Ink(
                          padding: EdgeInsets.all(16),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: LiviThemes.colors.gray200,
                            shape: BoxShape.circle,
                          ),
                          child: LiviThemes.icons.checkCircleFilledIcon(
                              color: LiviThemes.colors.gray700)),
                    ),
                    SizedBox(height: 12),
                    LiviTextStyles.interSemiBold14(Strings.yesIHaveTakenIt,
                        color: LiviThemes.colors.gray700)
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      radius: 80,
                      borderRadius: BorderRadius.circular(80),
                      onTap: () => dispenseFromPod(context),
                      child: Ink(
                          padding: EdgeInsets.all(16),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: LiviThemes.colors.gray200,
                            shape: BoxShape.circle,
                          ),
                          child: LiviThemes.icons.smallLiviPodIcon(
                              color: LiviThemes.colors.gray700)),
                    ),
                    SizedBox(height: 12),
                    LiviTextStyles.interSemiBold14(Strings.dispenseFromPOD,
                        color: LiviThemes.colors.gray700)
                  ],
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
