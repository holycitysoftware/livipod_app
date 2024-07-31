import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/components.dart';
import '../../controllers/auth_controller.dart';
import '../../models/enums.dart';
import '../../models/medication_history.dart';
import '../../models/models.dart';
import '../../services/medication_service.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../../utils/utils.dart';

final _dateFormat = DateFormat('E, MMM d - ');

class HistoryDetailsPage extends StatefulWidget {
  final MedicationHistory medicationHistory;

  const HistoryDetailsPage({super.key, required this.medicationHistory});

  @override
  State<HistoryDetailsPage> createState() => _HistoryDetailsPageState();
}

class _HistoryDetailsPageState extends State<HistoryDetailsPage> {
  var loading = false;
  Medication? medication;
  @override
  void initState() {
    getMedication();
    super.initState();
  }

  Future<void> getMedication() async {
    medication = await MedicationService()
        .getMedication(widget.medicationHistory.medicationId);
  }

  String getDateTime() {
    return _dateFormat.format(widget.medicationHistory.dateTime) +
        formartTimeOfDay(
            TimeOfDay(
              hour: widget.medicationHistory.dateTime.hour,
              minute: widget.medicationHistory.dateTime.minute,
            ),
            Provider.of<AuthController>(context, listen: false)
                .appUser!
                .useMilitaryTime);
  }

  Future<void> takeMedication(MedicationHistory medicationHistory) async {
    setState(() {
      loading = true;
    });
    medicationHistory.isOverride = true;
    medicationHistory.outcome = DosingOutcome.taken;
    await MedicationService().updateMedicationHistory(medicationHistory);
    setState(() {
      loading = false;
    });
    Navigator.of(context).pop();
  }

  void dispenseFromPod() {
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
                  dosageForm: widget.medicationHistory.dosageForm ??
                      DosageForm.aerosol_spray,
                  color: LiviThemes.colors.gray700),
            ),
            Spacer(),
            LiviTextStyles.interMedium16(getDateTime(),
                color: LiviThemes.colors.gray500),
            LiviTextStyles.interSemiBold20(
                widget.medicationHistory.medicationName,
                color: LiviThemes.colors.gray500),
            if (widget.medicationHistory.dosageForm != null)
              LiviTextStyles.interRegular16(
                  '${widget.medicationHistory.dosageForm!.description}, ${widget.medicationHistory.strength}',
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
                      onTap: () => takeMedication(widget.medicationHistory),
                      child: Ink(
                          padding: EdgeInsets.all(16),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: LiviThemes.colors.gray200,
                            shape: BoxShape.circle,
                          ),
                          child: loading
                              ? SizedBox(
                                  height: 12,
                                  width: 12,
                                  child: CircularProgressIndicator(
                                    color: LiviThemes.colors.gray700,
                                  ),
                                )
                              : LiviThemes.icons.checkCircleFilledIcon(
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
                      onTap: () => dispenseFromPod(),
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
