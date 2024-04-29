import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Center(
        child: Text('History Page'),
      ),
    );
  }
}
