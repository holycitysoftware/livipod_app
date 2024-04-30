import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../views.dart';

class MedicationsPage extends StatefulWidget {
  const MedicationsPage({super.key});

  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  final FocusNode focusNode = FocusNode();

  void goToSearchMedications({String? medication}) {
    Navigator.pushNamed(context, SearchMedicationPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.yourMedications,
        onPressed: goToSearchMedications,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: LiviTextStyles.interSemiBold36(
                  Strings.noMedicationsAddedYet,
                  textAlign: TextAlign.center),
            ),
            LiviThemes.spacing.heightSpacer16(),
            LiviTextStyles.interRegular16(Strings.typeTheNameOfTheMedicine,
                textAlign: TextAlign.center),
            LiviThemes.spacing.heightSpacer16(),
            LiviSearchBar(
              onFieldSubmitted: (e) {
                goToSearchMedications(medication: e);
              },
              focusNode: focusNode,
            ),
            Spacer(
              flex: 2,
            ),
          ]),
        ),
      ),
    );
  }
}
