import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

class FinishRegistrationPage extends StatelessWidget {
  const FinishRegistrationPage({super.key});

  Future<void> goToLoginPage(BuildContext context) async {
    Navigator.popUntil(context, (route) {
      return route.settings.name == '/sms-flow-page';
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
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: LiviFilledButton(
                text: Strings.addMedication,
                showArrow: true,
                onTap: () {
                  //TOOD: herre
                  goToLoginPage(context);
                }),
          ),
          body: Column(
            children: [
              BackBar(
                trailing: TextButton(
                    onPressed: () {
                      //TODO: herre
                    },
                    child: LiviTextStyles.interMedium16(Strings.skip,
                        color: LiviThemes.colors.gray500)),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: LiviThemes.icons.welcomeImage),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: LiviTextStyles.interSemiBold36(
                  Strings.welcomeToLiviPodClean,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: LiviTextStyles.interRegular16(
                  Strings.yourAccountHasBeenCreatedLets,
                  color: LiviThemes.colors.gray600,
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
