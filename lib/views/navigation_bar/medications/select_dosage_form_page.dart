import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/enums.dart';
import '../../../models/models.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';
import '../../views.dart';

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
  DosageForm dosageForm = DosageForm.none;

  bool get isSelected =>
      dosageForm != DosageForm.none && dosageForm == medication!.dosageForm;

  @override
  void initState() {
    medication = widget.medication;
    super.initState();
  }

  Future<void> goToSelectMedicationStrength() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectDosageFormPage(medication: medication!)),
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
          onTap: goToSelectMedicationStrength,
        ),
      ),
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
                  ),
                  _buildDosageFormCard(
                    dosageForm: DosageForm.tablet,
                  ),
                  _buildDosageFormCard(
                    dosageForm: DosageForm.drops,
                  ),
                  _buildDosageFormCard(
                    dosageForm: DosageForm.injection,
                  ),
                  _buildDosageFormCard(
                    dosageForm: DosageForm.ointment,
                  ),
                  _buildDosageFormCard(
                    dosageForm: DosageForm.liquid,
                  ),
                  _buildDosageFormCard(
                    dosageForm: DosageForm.patch,
                  ),
                  _buildDosageFormCard(
                    dosageForm: DosageForm.other,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getIcon(DosageForm dosageForm, {bool isSelected = false}) {
    final color = isSelected ? null : LiviThemes.colors.gray300;
    switch (dosageForm) {
      case DosageForm.none:
        return SizedBox();
      case DosageForm.capsule:
        return LiviThemes.icons.capsuleIcon(color: color);
      case DosageForm.tablet:
        return LiviThemes.icons.tabletIcon(color: color);
      case DosageForm.drops:
        return LiviThemes.icons.dropsIcon(color: color);
      case DosageForm.injection:
        return LiviThemes.icons.injectionIcon(color: color);
      case DosageForm.ointment:
        return LiviThemes.icons.ointmentIcon(color: color);
      case DosageForm.liquid:
        return LiviThemes.icons.liquidIcon(color: color);
      case DosageForm.patch:
        return LiviThemes.icons.patchIcon(color: color);
      case DosageForm.other:
        return LiviThemes.icons.otherDotsHorizontalIcon(color: color);
    }
  }

  Widget _buildDosageFormCard({required DosageForm dosageForm}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: LiviThemes.colors.brand600.withOpacity(0.24),
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (medication != null) {
            setState(() {
              medication!.dosageForm = dosageForm;
            });
          }
        },
        child: Container(
          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: LiviThemes.colors.baseWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: LiviThemes.colors.gray200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getIcon(
                  dosageForm,
                  isSelected: isSelected,
                ),
                LiviTextStyles.interRegular16(dosageForm.description,
                    color: isSelected
                        ? LiviThemes.colors.brand600
                        : LiviThemes.colors.gray400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
