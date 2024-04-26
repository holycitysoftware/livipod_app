import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../components/buttons/livi_filled_button_white.dart';
import '../../components/components.dart';
import '../../controllers/controllers.dart';
import '../../models/models.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

class FinishRegistrationPage extends StatelessWidget {
  const FinishRegistrationPage({super.key});

  Future<void> goToLoginPage(BuildContext context) async {
    Navigator.popUntil(context, (route) {
      ///change it to / pattern
      return route.settings.name == 'SmsFlowPage';
    });
  }

  String getUserType(AppUserType userType) {
    switch (userType) {
      case AppUserType.assistedUser:
        return 'Assisted User';
      case AppUserType.caredForUser:
        return 'Cared-for User';
      case AppUserType.selfGuidedUser:
        return 'Self-Guided User';
      default:
        return 'SelfGuided User';
    }
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
                  LiviThemes.spacing.heightSpacer16(),
                  //TODO:change this
                  Consumer<AuthController>(builder: (context, value, child) {
                    return LiviTextStyles.interRegular18(
                        'Your persona is ${getUserType(value.personaType ?? AppUserType.selfGuidedUser)}',
                        textAlign: TextAlign.center,
                        color: LiviThemes.colors.baseWhite);
                  }),
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
