import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LiviThemes.icons.liviPod,
        ],
      ),
    );
  }
}
