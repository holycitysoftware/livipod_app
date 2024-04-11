import 'package:flutter/foundation.dart';
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future searchDrugs() async {
    if (_controller.text.isNotEmpty) {
      final results = await _service.searchDrugs(_controller.text);
      if (kDebugMode) {
        print(results);
      }
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
        color: Colors.grey,
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: _controller,
              ),
              ElevatedButton(
                  onPressed: () {
                    searchDrugs();
                  },
                  child: const Text('Search'))
            ],
          ),
        ),
      ),
    );
  }
}
