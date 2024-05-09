import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../services/medication_service.dart';
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchMedicationPage(),
      ),
    );
  }

  Future<void> goToEditMedication(Medication medication) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMedicationPage(
          medication: medication,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.yourMedications,
        onPressed: goToSearchMedications,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToSearchMedications,
        backgroundColor: LiviThemes.colors.brand600,
        child: LiviThemes.icons.plusIcon(
          color: LiviThemes.colors.baseWhite,
        ),
      ),
      body: Consumer<AuthController>(builder: (context, value, child) {
        return StreamBuilder<List<Medication>>(
            stream:
                MedicationService().listenToMedicationsRealTime(value.appUser!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final medications = snapshot.data!;
                return ListView.builder(
                  itemCount: medications.length,
                  itemBuilder: (context, index) {
                    final medication = medications[index];
                    return MedicationCard(
                      medication: medication,
                      onTap: () => goToEditMedication(medication),
                    );
                  },
                );
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: LiviTextStyles.interSemiBold36(
                              Strings.noMedicationsAddedYet,
                              textAlign: TextAlign.center),
                        ),
                        LiviThemes.spacing.heightSpacer16(),
                        LiviTextStyles.interRegular16(
                            Strings.typeTheNameOfTheMedicine,
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
              );
            });
      }),
    );
  }
}
