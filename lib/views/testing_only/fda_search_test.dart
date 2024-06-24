import 'package:flutter/material.dart';

import '../../services/fda_service.dart';

class FdaSearchTest extends StatefulWidget {
  FdaSearchTest({super.key});

  @override
  State<FdaSearchTest> createState() => _FdaSearchTestState();
}

class _FdaSearchTestState extends State<FdaSearchTest> {
  final TextEditingController _controller = TextEditingController();
  final FdaService _service = FdaService();
  String _genericName = '';
  String _dosageForm = '';
  String _strength = '';

  List<String> list = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future searchDrugs(bool isSearch) async {
    if (_controller.text.isNotEmpty) {
      list.clear();
      final results =
          await _service.searchDrugs(_controller.text, isSearch, null, null);

      setState(() {
        list.addAll(results);
      });
    }
  }

  Future selectGenericName(String genericName) async {
    _controller.clear();
    list.clear();
    final dosageFormList =
        await _service.searchDrugs(genericName, false, null, null);

    setState(() {
      list.addAll(dosageFormList);
    });

    setState(() {
      _genericName = genericName;
    });
  }

  Future selectDosageForm(String dosageForm) async {
    _controller.clear();
    list.clear();
    final strengthList =
        await _service.searchDrugs(_genericName, false, dosageForm, null);

    setState(() {
      list.addAll(strengthList);
    });

    setState(() {
      _dosageForm = dosageForm;
    });
  }

  void selectStrength(String strength) {
    _controller.clear();
    list.clear();

    setState(() {
      _strength = strength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FDA Drug Search'),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Center(
              child: Column(
            children: [
              if (_genericName.isEmpty) ...[
                TextField(
                  controller: _controller,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        list.clear();
                      });
                    } else {
                      searchDrugs(true);
                    }
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final genericName = list[index];
                      return ListTile(
                        onTap: () {
                          selectGenericName(genericName);
                        },
                        title: Text(
                          genericName,
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                )
              ] else if (_dosageForm.isEmpty) ...[
                Text(_genericName),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final dosageForm = list[index];
                      return ListTile(
                        onTap: () {
                          selectDosageForm(dosageForm);
                        },
                        title: Text(
                          dosageForm,
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                )
              ] else if (_strength.isEmpty) ...[
                Text('$_genericName $_dosageForm'),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final strength = list[index];
                      return ListTile(
                        onTap: () {
                          selectStrength(strength);
                        },
                        title: Text(
                          strength,
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                )
              ] else ...[
                Text('$_genericName $_strength $_dosageForm'),
              ],
              ElevatedButton(onPressed: () => clear(), child: Text('Reset'))
            ],
          )),
        ));
  }

  void clear() {
    setState(() {
      _dosageForm = '';
      _genericName = '';
      _strength = '';
      _controller.clear();
      list.clear();
    });
  }
}
