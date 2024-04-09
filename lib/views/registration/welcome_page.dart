import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../themes/livi_spacing/livi_spacing.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../views.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  Future<void> goToLoginPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> goToCreateAccountPage(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
  }

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
            LiviTextStyles.interSemiBold24(Strings.welcomeToLiviPod),
            Spacer(flex: 2),
            LiviPodWidget(),
            Spacer(flex: 3),
            LiviFilledButton(
                text: Strings.logIn, onTap: () => goToLoginPage(context)),
            LiviThemes.spacing.heightSpacer8(),
            LiviTextButton(
                text: Strings.signUp,
                onTap: () => goToCreateAccountPage(context)),
            LiviThemes.spacing.heightSpacer16(),
          ],
        ),
      ),
    );
  }
}
