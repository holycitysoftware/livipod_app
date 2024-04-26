import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/buttons/livi_filled_button_white.dart';
import '../../components/components.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../views.dart';

class FinishRegistrationPage extends StatelessWidget {
  const FinishRegistrationPage({super.key});

  Future<void> goToLoginPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SmsFlowPage(isLoginPage: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: LiviThemes.icons.splashBackgroundImage,
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Spacer(),
                  LiviThemes.icons.logoWhite,
                  LiviThemes.spacing.heightSpacer16(),
                  LiviTextStyles.interMedium24(Strings.welcomeToLiviPod,
                      color: LiviThemes.colors.baseWhite),
                  LiviThemes.spacing.heightSpacer4(),
                  LiviTextStyles.interRegular18(
                      Strings.yourAccountHasBeenCreatedStart,
                      textAlign: TextAlign.center,
                      color: LiviThemes.colors.baseWhite),
                  Spacer(),
                  LiviFilledButtonWhite(
                      text: Strings.addMedication,
                      onTap: () {
                        //TOOD: herre
                        goToLoginPage(context);
                      }),
                  LiviThemes.spacing.heightSpacer8(),
                  LiviTextButton(
                    color: LiviThemes.colors.baseWhite,
                    text: Strings.skip,
                    onTap: () {
                      //TOOD: herre
                      goToLoginPage(context);
                    },
                    isCloseToNotch: true,
                  ),
                  LiviThemes.spacing.heightSpacer8(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
