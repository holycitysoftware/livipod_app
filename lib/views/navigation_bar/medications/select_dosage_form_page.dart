import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/enums.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/logger.dart';
import '../../../utils/strings.dart';
import '../../../utils/utils.dart';
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
  DosageForm dosageForm = DosageForm.none;
  final FdaService _service = FdaService();
  List<String> dosageForms = [];
  bool isLoading = false;
  bool get isSelected => dosageForm != DosageForm.none;

  @override
  void initState() {
    searchDosageForms();
    super.initState();
  }

  Future searchDosageForms() async {
    try {
      setState(() {
        isLoading = true;
      });
      dosageForms =
          await _service.searchDrugs(widget.medication.name, false, null, null);
    } catch (e, s) {
      logger(e.toString());
      logger(s.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Iterable<DosageForm> get dosageFormList {
    if (dosageForms.isEmpty) {
      return DosageForm.values.sublist(1);
    }
    var list = <DosageForm>{};
    for (final dosageForm in dosageForms) {
      for (final value in DosageForm.values) {
        final add =
            dosageForm.toUpperCase().contains(value.description.toUpperCase());
        if (add) {
          list.add(value);
        }
      }
    }
    return list;
  }

  Future<void> goToSelectMedicationStrength() async {
    widget.medication.dosageForm = dosageForm;
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              SelectMedicationStrength(medication: widget.medication)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: LiviFilledButton(
          enabled: isSelected,
          isCloseToNotch: true,
          showArrow: true,
          text: Strings.continueText,
          onTap: goToSelectMedicationStrength,
        ),
      ),
      appBar: LiviAppBar(
        title: widget.medication.getNameStrengthDosageForm(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LiviTextStyles.interSemiBold36(
            Strings.selectDosageForm,
            textAlign: TextAlign.center,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  children: dosageFormList
                      .map((dosageForm) => _buildDosageFormCard(
                            dosageForm: dosageForm,
                          ))
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget getIcon(DosageForm dosageForm, {bool isSelected = false}) {
    final color =
        dosageForm == this.dosageForm || this.dosageForm == DosageForm.none
            ? null
            : LiviThemes.colors.gray300;
    return dosageFormIcon(dosageForm: dosageForm, color: color);
  }

  Widget _buildDosageFormCard({required DosageForm dosageForm}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow:
            dosageForm == this.dosageForm && this.dosageForm != DosageForm.none
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
          if (widget.medication != null) {
            setState(() {
              widget.medication.dosageForm = dosageForm;
              this.dosageForm = widget.medication.dosageForm;
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
                    color: this.dosageForm == dosageForm
                        ? LiviThemes.colors.brand600
                        : LiviThemes.colors.gray400,
                    maxLines: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
