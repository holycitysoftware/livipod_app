import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/logger.dart';
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
  final FdaService _service = FdaService();
  List<String> strengthList = [];
  bool isLoading = false;

  @override
  void initState() {
    searchStrengths();
    super.initState();
  }

  void goToFrequencyPage() {
    widget.medication.strength = selectedStrength;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectFrequencyPage(
          medication: widget.medication,
        ),
      ),
    );
  }

  Future searchStrengths() async {
    try {
      setState(() {
        isLoading = true;
      });
      widget.medication.strength = selectedStrength;
      strengthList = await _service.searchDrugs(widget.medication.name, false,
          widget.medication.dosageForm.description.toUpperCase(), null);
    } catch (e, s) {
      logger(e.toString());
      logger(s.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: LiviFilledButton(
          isCloseToNotch: true,
          enabled: selectedStrength.isNotEmpty,
          showArrow: true,
          text: Strings.continueText,
          onTap: goToFrequencyPage,
        ),
      ),
      appBar: LiviAppBar(
        title: widget.medication.getNameStrengthDosageForm(),
      ),
      body: Column(
        children: [
          LiviTextStyles.interSemiBold36(
            Strings.selectMedicationStrength,
            textAlign: TextAlign.end,
          ),
          LiviThemes.spacing.heightSpacer32(),
          if (isLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: strengthList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: LiviThemes.colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: selectedStrength == strengthList[index]
                            ? LiviThemes.colors.brand600
                            : LiviThemes.colors.gray300,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        selectedStrength = strengthList[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: LiviTextStyles.interSemiBold16(
                                strengthList[index],
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                              ),
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
