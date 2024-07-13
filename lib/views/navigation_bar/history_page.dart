import 'package:flutter/material.dart';

import '../../components/bars/livi_app_bar.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: LiviThemes.colors.baseWhite,
        appBar: LiviAppBar(
          title: 'History Page',
          shouldNeverShowBackButton: true,
        ),
        body: Center(
          child: Text('History Page'),
        ),
      ),
    );
  }
}
