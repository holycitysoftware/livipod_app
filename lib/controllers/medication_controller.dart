import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/medication_service.dart';
import 'auth_controller.dart';

class MedicationsController extends ChangeNotifier {
  final MedicationService _medicationService = MedicationService();
  List<Medication> medications = [];

  List<Medication> get users => medications;

  MedicationsController(AuthController authController) {
    _medicationService
        .listenToMedicationsRealTime(authController.appUser!)
        .listen(_onMedsDataChanged);
  }

  void _onMedsDataChanged(List<Medication> medications) {
    this.medications = medications;
    notifyListeners();
  }
}
