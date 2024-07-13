import 'package:flutter/material.dart';

import '../../models/enums.dart';
import '../../models/models.dart';
import '../../themes/livi_themes.dart';
import '../../utils/utils.dart';
import '../components.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final Function()? onTap;
  final DosageForm? dosageForm;
  final bool useMilitaryTime;
  const MedicationCard({
    super.key,
    required this.medication,
    required this.onTap,
    this.dosageForm,
    required this.useMilitaryTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: LiviThemes.colors.baseWhite,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (dosageForm != null)
                  Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: LiviThemes.colors.brand50,
                      borderRadius: BorderRadius.circular(64),
                    ),
                    child: dosageFormIcon(dosageForm: dosageForm!),
                  ),
                LiviThemes.spacing.widthSpacer8(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LiviTextStyles.interSemiBold16(
                          medication.getNameStrengthDosageForm()),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: medication
                                  .getScheduleDescriptions(useMilitaryTime)
                                  .map((e) => LiviTextStyles.interRegular14(e,
                                      maxLines: 20))
                                  .toList(),
                            ),
                          )

                          // for (final schedule in medication.schedules)
                          //   LiviTextStyles.interRegular14(schedule
                          //       .getScheduleDescription(medication.type)),
                        ],
                      ),
                      LiviThemes.spacing.heightSpacer6(),
                      Row(
                        children: [
                          LiviThemes.icons.boxRight(
                              color: LiviThemes.colors.brand600, height: 20),
                          LiviThemes.spacing.widthSpacer4(),
                          if (medication.inventoryQuantity != null)
                            LiviTextStyles.interRegular14(
                                '${medication.inventoryQuantity} left',
                                color: LiviThemes.colors.brand600),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(64),
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: LiviThemes.icons.edit1Widget(height: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
