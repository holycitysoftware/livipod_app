import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  String _drugName = '';

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
              if (_drugName.isEmpty) ...[
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
                // ElevatedButton(
                //     onPressed: () {
                //       searchDrugs(true);
                //     },
                //     child: const Text('Search')),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final genericName = list[index];
                      return ListTile(
                        title: Text(
                          genericName,
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                )
              ]
            ],
          )),
        ));
  }
}
