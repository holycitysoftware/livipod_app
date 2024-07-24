import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import '../../../services/medication_service.dart';
import '../../../services/services.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';
import '../../views.dart';
import 'select_frequency_page.dart';

class MedicationsPage extends StatefulWidget {
  const MedicationsPage({super.key});

  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  final FocusNode focusNode = FocusNode();
  final searchTextController = TextEditingController();

  void goToSearchMedications({String? medication}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchMedicationPage(
          medication: medication,
        ),
      ),
    );
  }

  Future<void> goToEditMedication(Medication medication) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        maintainState: false,
        builder: (context) => SelectFrequencyPage(
          medication: medication,
          isEdit: true,
        ),
      ),
    ).then((e) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: LiviThemes.colors.gray100,
        appBar: LiviAppBar(
          title: Strings.yourMedications,
          shouldNeverShowBackButton: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: goToSearchMedications,
          backgroundColor: LiviThemes.colors.brand600,
          child: LiviThemes.icons.plusIcon(
            color: LiviThemes.colors.baseWhite,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder(
            initialData:
                Provider.of<AuthController>(context, listen: false).appUser,
            stream: AppUserService().listenToUserRealTime(
                Provider.of<AuthController>(context, listen: false).appUser!),
            builder: (context, appUserSnapshot) {
              final appUser = appUserSnapshot.data;

              return StreamBuilder<List<Medication>>(
                stream:
                    MedicationService().listenToMedicationsRealTime(appUser!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LiviCircularAnimation();
                  }
                  if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                    final medications = snapshot.data!;
                    medications.sort((a, b) =>
                        a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                    return ListView.builder(
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        final medication = medications[index];
                        return MedicationCard(
                          useMilitaryTime: appUser.useMilitaryTime,
                          dosageForm: medication.dosageForm,
                          medication: medication,
                          onTap: () => goToEditMedication(medication),
                        );
                      },
                    );
                  }
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 48),
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
                                onTap: () => goToSearchMedications(
                                    medication: searchTextController.text),
                                controller: searchTextController,
                                onFieldSubmitted: (e) {
                                  goToSearchMedications(medication: e);
                                },
                                focusNode: focusNode,
                              ),
                            ]),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class LiviCircularAnimation extends StatelessWidget {
  const LiviCircularAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      key: Key('circular-animation'),
    ));
  }
}
