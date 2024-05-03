import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/enums.dart';
import '../../../models/models.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';

class SelectDosageFormPage extends StatefulWidget {
  static const String routeName = '/select-dosage-form-page';

  final Medication medication;
  const SelectDosageFormPage({
    super.key,
    required this.medication,
  });

  @override
  State<SelectDosageFormPage> createState() => _SelectDosageFormPageState();
}

class _SelectDosageFormPageState extends State<SelectDosageFormPage> {
  Medication? medication;

  @override
  void initState() {
    medication = widget.medication;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: widget.medication.name,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LiviTextStyles.interSemiBold36(
            Strings.selectDosageForm,
            textAlign: TextAlign.center,
          ),
          LiviThemes.spacing.heightSpacer32(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                children: [
                  _buildDosageFormCard(
                      dosageForm: DosageForm.capsule,
                      icon: LiviThemes.icons.capsuleIcon()),
                  _buildDosageFormCard(
                      dosageForm: DosageForm.tablet,
                      icon: LiviThemes.icons.tabletIcon()),
                  _buildDosageFormCard(
                      dosageForm: DosageForm.drops,
                      icon: LiviThemes.icons.dropsIcon()),
                  _buildDosageFormCard(
                      dosageForm: DosageForm.injection,
                      icon: LiviThemes.icons.injectionIcon()),
                  _buildDosageFormCard(
                      dosageForm: DosageForm.ointment,
                      icon: LiviThemes.icons.ointmentIcon()),
                  _buildDosageFormCard(
                      dosageForm: DosageForm.liquid,
                      icon: LiviThemes.icons.liquidIcon()),
                  _buildDosageFormCard(
                      dosageForm: DosageForm.patch,
                      icon: LiviThemes.icons.patchIcon()),
                  _buildDosageFormCard(
                      dosageForm: DosageForm.other,
                      icon: LiviThemes.icons.otherDotsHorizontalIcon())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosageFormCard(
      {required DosageForm dosageForm, required Widget icon}) {
    return Container(
      decoration: BoxDecoration(
        color: LiviThemes.colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LiviThemes.colors.gray200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (medication != null) {
            medication!.dosageForm = dosageForm;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              Text(dosageForm.description),
            ],
          ),
        ),
      ),
    );
  }
}
