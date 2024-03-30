import 'package:flutter/material.dart';

import '../../components/buttons/livi_filled_button.dart';
import '../../components/buttons/livi_text_button.dart';
import '../../components/components.dart';
import '../../themes/livi_spacing/livi_spacing.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacer_16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 3),
            LiviThemes.icons.logo,
            Spacer(),
            LiviTextStyles.interSemiBold24(data: Strings.welcomeToLiviPod),
            Spacer(flex: 2),
            LiviPodWidget(),
            Spacer(flex: 3),
            LiviFilledButton(text: Strings.logIn, onTap: () {}),
            LiviThemes.spacing.heightSpacer8(),
            LiviTextButton(text: Strings.signUp, onTap: () {}),
            LiviThemes.spacing.heightSpacer16(),
          ],
        ),
      ),
    );
  }
}
