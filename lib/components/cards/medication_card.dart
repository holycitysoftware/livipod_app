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
  const MedicationCard({
    super.key,
    required this.medication,
    required this.onTap,
    this.dosageForm,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LiviTextStyles.interSemiBold16(medication.name),
                    Row(
                      children: [
                        if (medication.dosageForm.description.isNotEmpty)
                          LiviTextStyles.interRegular14(
                              '${medication.dosageForm.description}, '),
                        if (medication.strength != null &&
                            medication.strength.isNotEmpty)
                          LiviTextStyles.interRegular14(
                              '${medication.strength}, '),
                        if (medication.type.description.isNotEmpty)
                          LiviTextStyles.interRegular14(
                              '${medication.type.description}, '),
                        if (medication.inventoryQuantity != null &&
                            medication.inventoryQuantity > 0)
                          LiviTextStyles.interRegular14(
                              medication.inventoryQuantity.toString()),
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
                              '${medication.inventoryQuantity.toString()} left',
                              color: LiviThemes.colors.brand600),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: onTap,
                  child: LiviThemes.icons.chevronRight(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
