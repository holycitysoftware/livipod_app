import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../services/fda_service.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';
import '../../views.dart';

class SearchMedicationPage extends StatefulWidget {
  static const String routeName = '/search-medication-page';
  final String? medication;
  const SearchMedicationPage({
    super.key,
    this.medication,
  });

  @override
  State<SearchMedicationPage> createState() => _SearchMedicationPageState();
}

class _SearchMedicationPageState extends State<SearchMedicationPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FdaService _service = FdaService();
  String results = '';

  @override
  void initState() {
    if (widget.medication != null) {
      _controller.text = widget.medication!;
      searchDrugs();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future searchDrugs() async {
    // if (_controller.text.isNotEmpty) {
    //   results = await _service.searchDrugs(_controller.text);
    //   if (kDebugMode) {
    //     print(results);
    //   }
    // }
  }

  Future<void> goToSelectDosageForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDosageFormPage(
          medication: Medication(name: 'Achiphex (rabeprazole)'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.addMedication,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: LiviSearchBar(
                focusNode: _focusNode,
                onFieldSubmitted: (e) {
                  searchDrugs();
                },
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: goToSelectDosageForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LiviTextStyles.interSemiBold16(
                              'Achiphex (rabeprazole)'),
                          LiviTextStyles.interRegular16(
                              'Manufacturer: Pfizer Inc.',
                              color: LiviThemes.colors.gray500),
                          LiviThemes.spacing.heightSpacer16(),
                          LiviDivider(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
