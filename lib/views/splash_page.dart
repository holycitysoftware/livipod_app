import 'package:flutter/material.dart';

import '../components/components.dart';
import '../themes/livi_themes.dart';
import '../utils/strings.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: LiviThemes.icons.splashBackgroundImage,
            // fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LiviThemes.icons.logoWhite,
            LiviTextStyles.interMedium24(Strings.welcomeToLiviPod),
            LiviThemes.icons.livipodText,
          ],
        ),
      ),
    );
  }
}
