import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:wifi_scan/wifi_scan.dart';

import '../../../components/components.dart';
import '../../../controllers/controllers.dart';
import '../../../models/models.dart';
import '../../../services/app_user_service.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';
import '../../views.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final appUserService = AppUserService();
  final InAppReview inAppReview = InAppReview.instance;
  String buildNumber = '';

  @override
  void initState() {
    super.initState();
    getBuildNumber();
  }

  Future<void> getBuildNumber() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    buildNumber = '${packageInfo.version}+${packageInfo.buildNumber}';
    setState(() {});
  }

  Future<void> logout(
      AuthController authController, BuildContext context) async {
    await LiviAlertDialog.showAlertDialog(context);
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomePage(),
      ),
    );
    await authController.signOut();
  }

  Future<void> goToMyPodsPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyPodsPage(),
      ),
    );
  }

  Future<void> showAppReview() async {
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      //TODO: hyperlink to app on playstore/appstore
    }
  }

  Future<void> goToEditInfoPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditInfoPage(),
      ),
    );
  }

  Future<void> goToEditCaregiver(BuildContext context, AppUser user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCaregiverPage(
          appUser: user,
        ),
      ),
    );
  }

  Future<void> goToAddCaregiver(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCaregiverPage(),
      ),
    );
  }

  Future<void> goToNotificationsPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationsPage(),
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

  Future<void> goToSetupWifi(BuildContext context) async {
    final can = await WiFiScan.instance.canGetScannedResults();

    if (Platform.isAndroid && can == CanGetScannedResults.yes) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SetupWifiListPage(),
        ),
      );
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SetupWifiPage(),
      ),
    );
  }

  Future<void> updateAllowAutomaticDispensing(AppUser user, bool value) async {
    user.allowAutomaticDispensing = value;
    await appUserService.updateUser(user);
  }

  Future<void> updateAllowRemoteDispensing(AppUser user, bool value) async {
    user.allowRemoteDispensing = value;
    await appUserService.updateUser(user);
  }

  Future<void> updateMilitaryTime(AppUser user, bool value) async {
    user.useMilitaryTime = value;
    await appUserService.updateUser(user);
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
              NameCircleBox(
                name: authController.appUser!.name,
                profilePic: authController.appUser!.base64EncodedImage,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => goToEditInfoPage(context),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      // margin: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: LiviThemes.colors.baseWhite,
                          border: Border.all(
                            color: LiviThemes.colors.gray300,
                          ),
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
              StreamBuilder<AppUser>(
                  stream: appUserService.listenToUserRealTime(
                      Provider.of<AuthController>(context, listen: false)
                          .appUser!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 64),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapshot.data == null) {
                      return SizedBox();
                    }
                    final user = snapshot.data!;
                    return Column(
                      children: [
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
                              title: Text(Strings.setupWifi),
                              onTap: () => goToSetupWifi(context),
                              trailing: LiviThemes.icons.chevronRight(),
                            ),
                            LiviDivider(),
                            //TODO: BLE:Those options must be hidden if wifi is not setup
                            ListTile(
                              title: Text(Strings.allowAutomaticDispensing),
                              trailing: LiviSwitchButton(
                                value: user.allowAutomaticDispensing,
                                onChanged: (value) {
                                  updateAllowAutomaticDispensing(user, value);
                                },
                              ),
                            ),
                            LiviDivider(),
                            ListTile(
                              title: Text(Strings.allowRemoteDispensing),
                              trailing: LiviSwitchButton(
                                value: user.allowRemoteDispensing,
                                onChanged: (value) {
                                  updateAllowRemoteDispensing(user, value);
                                },
                              ),
                            ),
                          ],
                          titleIcon: LiviThemes.icons.smallLiviPodIcon(),
                          title: Strings.podSettings,
                        ),
                        contentBlock(
                          children: [
                            StreamBuilder<List<AppUser>>(
                                stream:
                                    appUserService.listenToCaregiversRealTime(
                                        authController.appUser!),
                                builder: (context, snapshot) {
                                  print(authController.appUser!.name);
                                  if (snapshot.data == null) {
                                    return SizedBox();
                                  }
                                  final user = snapshot.data!;
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final item = snapshot.data![index];
                                      return caregiverWidget(item, context);
                                    },
                                  );
                                }),
                            LiviInkWell(
                              onTap: () => goToAddCaregiver(context),
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
                              onTap: () => goToNotificationsPage(context),
                              leading: Icon(
                                Icons.notifications,
                                color: LiviThemes.colors.error500,
                              ),
                              title: Text(Strings.notifications),
                              trailing: LiviThemes.icons.chevronRight(),
                            ),
                            LiviDivider(),
                            // StreamBuilder<AppUser>(
                            //     stream: appUserService.listenToUserRealTime(
                            //         Provider.of<AuthController>(context, listen: false)
                            //             .appUser!),
                            //     builder: (context, snapshot) {
                            //       if (snapshot.data == null) {
                            //         return SizedBox();
                            //       }
                            //       final user = snapshot.data!;
                            //       return ListTile(
                            //         leading: Icon(
                            //           Icons.access_time_filled,
                            //           color: LiviThemes.colors.blue400,
                            //         ),
                            //         title: Text(Strings.militaryTime),
                            //         trailing: LiviSwitchButton(
                            //           value: user.useMilitaryTime,
                            //           onChanged: (value) {
                            //             updateMilitaryTime(user, value);
                            //           },
                            //         ),
                            //       );
                            //     }),
                            ListTile(
                              onTap: showAppReview,
                              leading: Icon(
                                Icons.feedback,
                                color: LiviThemes.colors.purple500,
                              ),
                              title: Text(Strings.shareFeedback),
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
                          titleIcon: LiviThemes.icons.settingsIcon(
                              height: 16, color: LiviThemes.colors.gray500),
                          title: Strings.settings,
                        ),
                        LiviFilledButton(
                          color: LiviThemes.colors.baseWhite,
                          text: Strings.logout,
                          borderColor: LiviThemes.colors.error300,
                          textColor: LiviThemes.colors.error600,
                          onTap: () => logout(authController, context),
                        ),
                        LiviThemes.spacing.heightSpacer16(),
                        Align(
                          child: LiviTextStyles.interRegular14(
                              'Build $buildNumber',
                              color: LiviThemes.colors.gray700),
                        ),
                        LiviThemes.spacing.heightSpacer12(),
                      ],
                    );
                  }),
            ],
          ),
        );
      }),
    );
  }

  Widget caregiverWidget(AppUser user, BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => goToEditCaregiver(context, user),
          leading: NameCircleBox(
            name: user.name,
            profilePic: user.base64EncodedImage,
            isSmaller: true,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LiviTextStyles.interSemiBold16(user.name),
              if (user.email != null && user.email!.isNotEmpty)
                LiviTextStyles.interMedium14(
                  user.email!,
                  color: LiviThemes.colors.gray500,
                ),
              LiviTextStyles.interMedium14(
                user.phoneNumber,
                color: LiviThemes.colors.gray500,
              ),
            ],
          ),
          trailing: LiviThemes.icons.chevronRight(),
        ),
        LiviDivider(),
      ],
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
