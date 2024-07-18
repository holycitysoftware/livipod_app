import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../services/fda_service.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/logger.dart';
import '../../../utils/string_ext.dart';
import '../../../utils/strings.dart';
import '../../views.dart';
import 'select_frequency_page.dart';

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
  Medication? medication;
  bool isLoading = false;
  List<String> medications = [];
  var customMed = false;

  @override
  void initState() {
    if (widget.medication != null) {
      _controller.text = widget.medication!;
      searchDrugs(true);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future searchDrugs(bool isSearch) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (_controller.text.isNotEmpty) {
        medications.clear();
        medications = await _service.searchDrugs(
            _controller.text.toLowerCase(), isSearch, null, null);
      }
    } catch (e, s) {
      logger(e.toString());
      logger(s.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> goToSelectDosageForm(
    String name,
  ) async {
    medication = Medication(name: name);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDosageFormPage(
          medication: medication!,
        ),
      ),
    );
  }

  Future<void> goToSelectFrequencyPage(
    String name,
  ) async {
    medication = Medication(name: name);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectFrequencyPage(
          medication: medication!,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: LiviSearchBar(
                controller: _controller,
                focusNode: _focusNode,
                onFieldSubmitted: (p0) {
                  setState(() {
                    customMed = true;
                  });
                },
                onChanged: (value) {
                  customMed = false;
                  if (value.isEmpty) {
                    setState(() {
                      medications.clear();
                    });
                  } else {
                    searchDrugs(true);
                  }
                },
              ),
            ),
            if (isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if ((medications.length == 0 && _controller.text.isNotEmpty) ||
                customMed) ...[
              Spacer(),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                height: 120,
                width: 250,
                child: LiviInkWell(
                  borderRadius: 8,
                  onTap: () => goToSelectFrequencyPage(_controller.text),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LiviTextStyles.interMedium16(
                        Strings.noResultsFound,
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LiviThemes.icons
                              .searchLgIcon(color: LiviThemes.colors.brand600),
                          SizedBox(width: 6),
                          LiviTextStyles.interRegular16(
                              '${Strings.continueWith} "${_controller.text}"',
                              color: LiviThemes.colors.brand600),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Spacer(),
            ] else
              Expanded(
                child: ListView.builder(
                  itemCount: medications.length + 1,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return LiviInkWell(
                        borderRadius: 8,
                        onTap: () => goToSelectFrequencyPage(_controller.text),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Row(
                            children: [
                              LiviTextStyles.interRegular16(
                                  Strings.continueWith),
                              LiviTextStyles.interRegular16(
                                  '"${_controller.text}"',
                                  color: LiviThemes.colors.brand600),
                            ],
                          ),
                        ),
                      );
                    }
                    final medication = medications[index - 1];
                    return InkWell(
                      radius: 8,
                      borderRadius: BorderRadius.circular(8),
                      overlayColor: MaterialStatePropertyAll(
                        LiviThemes.colors.brand600.withOpacity(0.1),
                      ),
                      onTap: () => goToSelectDosageForm(medication),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LiviThemes.spacing.heightSpacer16(),
                            LiviTextStyles.interSemiBold14(
                              medication.capitalizeFirstLetter(),
                            ),
                            LiviThemes.spacing.heightSpacer16(),
                            LiviDivider(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
