import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';
import '../../views.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> logout(
      AuthController authController, BuildContext context) async {
    await LiviAlertDialog.showAlertDialog(context);
    // await authController.signOut();
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => WelcomePage(),
    //   ),
    // );
  }

  Future<void> goToMyPodsPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyPodsPage(),
      ),
    );
  }

  Future<void> goToEditInfoPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditInfoPage(),
      ),
    );
  }

  Future<void> goToTermsPrivacyPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsPrivacyPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: LiviThemes.colors.gray100,
      child:
          Consumer<AuthController>(builder: (context, authController, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              NameCircleBox(appUser: authController.appUser!),

              LiviThemes.spacing.heightSpacer8(),
              LiviTextStyles.interBold20(
                authController.appUser!.name,
                color: LiviThemes.colors.baseBlack,
                textAlign: TextAlign.center,
              ),
              if (authController.appUser!.email != null)
                LiviTextStyles.interRegular14(
                  authController.appUser!.email!,
                  color: LiviThemes.colors.baseBlack,
                  textAlign: TextAlign.center,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => goToEditInfoPage(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Ink(
                      padding: EdgeInsets.all(12),
                      // margin: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: LiviThemes.colors.baseWhite,
                          border: Border.all(color: LiviThemes.colors.gray300),
                          borderRadius: BorderRadius.circular(8)),
                      child: LiviTextStyles.interMedium14(
                        Strings.editInfo,
                        color: LiviThemes.colors.baseBlack,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),

              contentBlock(
                children: [
                  ListTile(
                    onTap: () => goToMyPodsPage(context),
                    leading: LiviThemes.icons.devicesIcon(),
                    title: Text(Strings.myPods),
                    trailing: LiviThemes.icons.chevronRight(),
                  ),
                  LiviDivider(),
                  ListTile(
                    leading: LiviThemes.icons.wifiIcon(),
                    title: Text(Strings.allowAutomaticDispensing),
                    trailing: LiviSwitchButton(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                ],
                titleIcon: LiviThemes.icons.smallLiviPodIcon(),
                title: Strings.podSettings,
              ),
              contentBlock(
                children: [
                  ListTile(
                    leading: NameCircleBox(
                      appUser: authController.appUser!,
                      isSmaller: true,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LiviTextStyles.interSemiBold16('David Duranceau'),
                        LiviTextStyles.interMedium14(
                          'davidduranceau@pharmarigh',
                          color: LiviThemes.colors.gray500,
                        ),
                        LiviTextStyles.interMedium14(
                          '+1 (215) 268-8872',
                          color: LiviThemes.colors.gray500,
                        ),
                      ],
                    ),
                    trailing: LiviThemes.icons.chevronRight(),
                  ),
                  LiviDivider(),
                  LiviInkWell(
                    onTap: () {
                      print(' ha');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          LiviThemes.icons.plusIcon(),
                          LiviThemes.spacing.widthSpacer8(),
                          LiviTextStyles.interMedium16(
                            Strings.addCaregiver,
                            color: LiviThemes.colors.brand600,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
                titleIcon: LiviThemes.icons
                    .caregiverIcon(color: LiviThemes.colors.gray500),
                title: Strings.caregivers,
              ),
              // contentBlock([]),
              contentBlock(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color: LiviThemes.colors.error500,
                    ),
                    title: Text(Strings.notifications),
                    trailing: LiviThemes.icons.chevronRight(),
                  ),
                  LiviDivider(),
                  ListTile(
                    leading: Icon(
                      Icons.access_time_filled,
                      color: LiviThemes.colors.blue400,
                    ),
                    title: Text(Strings.militaryTime),
                    trailing: LiviSwitchButton(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                  LiviDivider(),
                  ListTile(
                    leading: Icon(
                      Icons.feedback,
                      color: LiviThemes.colors.purple500,
                    ),
                    title: Text(Strings.shareFeedback),
                    trailing: LiviThemes.icons.chevronRight(),
                  ),
                  LiviDivider(),
                  ListTile(
                    onTap: () => goToTermsPrivacyPage(context),
                    leading: Icon(
                      Icons.lock_rounded,
                      color: LiviThemes.colors.green500,
                    ),
                    title: Text(Strings.termsAndPrivacy),
                    trailing: LiviThemes.icons.chevronRight(),
                  ),
                ],
                titleIcon: LiviThemes.icons
                    .settingsIcon(height: 16, color: LiviThemes.colors.gray500),
                title: Strings.settings,
              ),
              LiviFilledButton(
                color: LiviThemes.colors.baseWhite,
                text: Strings.logout,
                borderColor: LiviThemes.colors.error300,
                textColor: LiviThemes.colors.error600,
                onTap: () => logout(authController, context),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget contentBlock(
      {required List<Widget> children,
      required String title,
      required Widget titleIcon}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              titleIcon,
              LiviThemes.spacing.widthSpacer8(),
              LiviTextStyles.interMedium14(title,
                  color: LiviThemes.colors.gray500),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
                color: LiviThemes.colors.baseWhite,
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
