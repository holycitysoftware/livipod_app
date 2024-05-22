import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../controllers/auth_controller.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../../utils/utils.dart';
import '../views.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> logout(
      AuthController authController, BuildContext context) async {
    await authController.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: LiviThemes.colors.gray100,
        body:
            Consumer<AuthController>(builder: (context, authController, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: LiviThemes.colors.gray400,
                    shape: BoxShape.circle,
                    border: Border.all(color: LiviThemes.colors.gray400),
                  ),
                  child: LiviTextStyles.interSemiBold36(
                    getFirstLettersOfName(authController.appUser!),
                    color: LiviThemes.colors.baseWhite,
                    textAlign: TextAlign.center,
                  ),
                ),
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

                contentBlock(
                  children: [
                    ListTile(
                      leading: LiviThemes.icons.devicesIcon(),
                      title: Text(Strings.myDevices),
                      trailing: LiviThemes.icons.chevronRight(),
                    ),
                    LiviDivider(),
                    ListTile(
                      leading: LiviThemes.icons.wifiIcon(),
                      title: Text(Strings.allowAutomaticDispensing),
                      trailing: LiviThemes.icons.chevronRight(),
                    ),
                  ],
                  titleIcon: LiviThemes.icons.smallLiviPodIcon(),
                  title: Strings.livipod,
                ),
                contentBlock(
                  children: [
                    ListTile(
                      leading: LiviThemes.icons.devicesIcon(),
                      title: Text(Strings.myDevices),
                      trailing: LiviThemes.icons.chevronRight(),
                    ),
                    LiviDivider(),
                    ListTile(
                      leading: LiviThemes.icons.wifiIcon(),
                      title: Text(Strings.allowAutomaticDispensing),
                      trailing: LiviThemes.icons.chevronRight(),
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
                      trailing: LiviThemes.icons.chevronRight(),
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
                      leading: Icon(
                        Icons.lock_rounded,
                        color: LiviThemes.colors.green500,
                      ),
                      title: Text(Strings.termsAndPrivacy),
                      trailing: LiviThemes.icons.chevronRight(),
                    ),
                  ],
                  titleIcon: LiviThemes.icons.settingsIcon(
                      height: 16, color: LiviThemes.colors.gray500),
                  title: Strings.settings,
                ),
                LiviFilledButtonWhite(
                  text: Strings.logout,
                  onTap: () => logout(authController, context),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget contentBlock(
      {required List<Widget> children,
      required String title,
      required Widget titleIcon}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
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
