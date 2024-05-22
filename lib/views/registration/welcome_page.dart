import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/components.dart';
import '../../themes/livi_spacing/livi_spacing.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../views.dart';

class WelcomePage extends StatelessWidget {
  static const String routeName = '/welcome-page';
  const WelcomePage({super.key});

  Future<void> goToLoginPage(BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => SmsFlowPage(
                isLoginPage: true,
              ),
          settings: RouteSettings(name: SmsFlowPage.routeName)),
    );
  }

  Future<void> goToCreateAccountPage(BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => SmsFlowPage(
                showIdentifyPersonaPage: true,
              ),
          settings: RouteSettings(name: SmsFlowPage.routeName)),
    );
  }

  SystemUiOverlayStyle getStyle(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final darkMode = brightness == Brightness.dark;
    if (Platform.isIOS) {
      return SystemUiOverlayStyle.dark;
    }
    if (darkMode) {
      return SystemUiOverlayStyle.light;
    }
    return SystemUiOverlayStyle.dark;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                onTap: () => goToCreateAccountPage(context),
                isCloseToNotch: true,
              ),
              LiviThemes.spacing.heightSpacer16(),
            ],
          ),
        ),
      ),
    );
  }
}
