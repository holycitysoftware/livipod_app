import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/enums.dart';
import '../../../models/models.dart';
import '../../../models/schedule_type.dart';
import '../../../services/medication_history.dart';
import '../../../services/medication_service.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/string_ext.dart';
import '../../../utils/strings.dart';
import '../../../utils/utils.dart';
import '../../views.dart';

const int _foreverYear = 2200;

class EditMedicationPage extends StatefulWidget {
  static const String routeName = '/select-frequency-page';
  final Medication medication;
  const EditMedicationPage({
    super.key,
    required this.medication,
  });

  @override
  State<EditMedicationPage> createState() => _EditMedicationPageState();
}

class _EditMedicationPageState extends State<EditMedicationPage> {
  var isEnabled = false;

  Future<void> updateMedication() async {
    widget.medication.appUserId =
        Provider.of<AuthController>(context, listen: false).appUser!.id;
    await MedicationService().updateMedication(widget.medication);
    Navigator.pop(context);
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
            onTap: () {},
          ),
        ),
        appBar: LiviAppBar(
          ///TODO: we need to see all the required fields
          ///and check if all THE REQUIREDS fields are filled :)
          title: widget.medication.name,
          onPressed: () {},
          tail: [
            LiviTextIcon(
              onPressed: isEnabled ? updateMedication : () {},
              enabled: isEnabled,
              text: Strings.save,
              icon: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: LiviThemes.icons.checkIcon(
                  color: isEnabled
                      ? LiviThemes.colors.brand600
                      : LiviThemes.colors.gray400,
                ),
              ),
            )
          ],
        ),
        body: Center(
          child: SizedBox(),
        ));
  }
}
