import 'package:flutter/material.dart';

import '../../components/bars/livi_app_bar.dart';
import '../../components/components.dart';
import '../../utils/strings.dart';
import '../views.dart';

class MedicationsPage extends StatefulWidget {
  const MedicationsPage({super.key});

  @override
  State<MedicationsPage> createState() => _MedicationsPageState();
}

class _MedicationsPageState extends State<MedicationsPage> {
  void goToAddMedication() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMedicationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiviAppBar(
        title: Strings.yourMedications,
        onPressed: goToAddMedication,
      ),
      body: Center(
        child: LiviTextStyles.interSemiBold36(Strings.noMedicationsAddedYet),
      ),
    );
  }
}
