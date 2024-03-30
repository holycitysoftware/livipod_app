import 'package:flutter/material.dart';

import '../../components/buttons/livi_filled_button.dart';
import '../../components/buttons/livi_text_button.dart';
import '../../components/components.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: LiviThemes.spacing.getSpacer_24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            LiviThemes.icons.logo,
            Spacer(),
            LiviTextStyles.interSemiBold24(data: Strings.welcomeToLiviPod),
            LiviThemes.spacing.heightSpacer12(),
            Container(
                alignment: Alignment.center,
                height: 280,
                child: LiviThemes.icons.liviPodImage),
            Spacer(),
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
