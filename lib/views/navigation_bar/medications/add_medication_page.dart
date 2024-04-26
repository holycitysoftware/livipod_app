import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../services/fda_service.dart';

class AddMedicationPage extends StatefulWidget {
  const AddMedicationPage({super.key});

  @override
  State<AddMedicationPage> createState() => _AddMedicationPageState();
}

class _AddMedicationPageState extends State<AddMedicationPage> {
  final TextEditingController _controller = TextEditingController();
  final FdaService _service = FdaService();
  String results = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future searchDrugs() async {
    if (_controller.text.isNotEmpty) {
      results = await _service.searchDrugs(_controller.text);
      if (kDebugMode) {
        print(results);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LiviAppBar(
        title: 'Add Medication',
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onSubmitted: (e) {
                  searchDrugs();
                },
                decoration: InputDecoration(
                  hintText: 'Add Medication',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(child: Text(results)),
          ],
        ),
      ),
    );
  }
}
