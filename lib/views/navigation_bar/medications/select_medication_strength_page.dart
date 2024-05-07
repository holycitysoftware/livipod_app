import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';
import 'select_frequency_page.dart';

class SelectMedicationStrength extends StatefulWidget {
  static const String routeName = '/select-medication-strength-page';
  final Medication medication;
  const SelectMedicationStrength({
    super.key,
    required this.medication,
  });

  @override
  State<SelectMedicationStrength> createState() =>
      _SelectMedicationStrengthState();
}

class _SelectMedicationStrengthState extends State<SelectMedicationStrength> {
  String selectedStrength = '';
  void goToFrequencyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  SelectFrequencyPage(
          medication: widget.medication,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: LiviFilledButton(
          isCloseToNotch: true,
          showArrow: true,
          text: Strings.continueText,
          onTap: goToFrequencyPage,
        ),
      ),
      appBar: LiviAppBar(
        title: widget.medication.name,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LiviTextStyles.interSemiBold36(
            Strings.selectMedicationStrength,
            textAlign: TextAlign.end,
          ),
          LiviThemes.spacing.heightSpacer32(),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: LiviThemes.colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: LiviThemes.colors.gray300,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      selectedStrength = '5 mg';
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LiviTextStyles.interSemiBold16(
                            '5 mg',
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
