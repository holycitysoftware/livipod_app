import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../controllers/auth_controller.dart';
import '../../../models/models.dart';
import '../../../models/notification_type.dart';
import '../../../services/app_user_service.dart';
import '../../../themes/livi_themes.dart';
import '../../../utils/strings.dart';

class NotificationsPage extends StatefulWidget {
  static const String routeName = '/my-pods-page';
  const NotificationsPage({
    super.key,
  });

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Medication? medication;
  final quantityController = TextEditingController(text: '10');
  bool isLoading = false;
  List<String> medications = [];
  late final AuthController authController;
  AppUser? appUser;
  final appUserService = AppUserService();

  @override
  void initState() {
    authController = Provider.of<AuthController>(context, listen: false);
    quantityController.text =
        authController.appUser!.lowInventoryQuantity.toString();
    super.initState();
  }

  @override
  void dispose() {
    saveUser();
    super.dispose();
  }

  Future<void> saveUser() async {
    final int typedQuantity = int.parse(quantityController.text);
    if (appUser != null && typedQuantity != appUser!.lowInventoryQuantity) {
      appUser!.lowInventoryQuantity = typedQuantity;
      await appUserService.updateUser(appUser!);
      await authController.getAppUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.notificationsSettings,
      ),
      body: StreamBuilder<AppUser>(
          stream: appUserService.listenToUserRealTime(
              Provider.of<AuthController>(context, listen: false).appUser!),
          builder: (context, snapshot) {
            appUser = snapshot.data;
            if (appUser == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: [
                LiviThemes.spacing.heightSpacer16(),
                notificationInfo(
                    Strings.notifications, Strings.stayInformedAboutImportant),
                notificationOption(
                  Strings.appNotification,
                  appUser!.usePushNotifications,
                  (e) => onChangedUseNotification(e, appUser!),
                ),
                notificationOption(
                  Strings.email,
                  appUser!.useEmail,
                  (e) => onChangedUseEmail(e, appUser!),
                ),
                LiviThemes.spacing.heightSpacer8(),
                LiviDivider(height: 8),
                LiviThemes.spacing.heightSpacer16(),
                notificationInfo(Strings.medicationPreferences,
                    Strings.chooseWithNotifications),
                notificationOption(
                  Strings.medicationsAvailable,
                  appUser!.medicationAvailable,
                  (e) => onChanged(
                      NotificationType.medicationAvailable, e, appUser!),
                ),
                notificationOption(
                  Strings.medicationsLate,
                  appUser!.medicationLate,
                  (e) =>
                      onChanged(NotificationType.medicationLate, e, appUser!),
                ),
                notificationOption(
                  Strings.medicationsDue,
                  appUser!.medicationDue,
                  (e) => onChanged(NotificationType.medicationDue, e, appUser!),
                ),
                notificationOption(
                  Strings.medicationsMissed,
                  appUser!.medicationMissed,
                  (e) =>
                      onChanged(NotificationType.medicationMissed, e, appUser!),
                ),
                LiviThemes.spacing.heightSpacer8(),
                LiviDivider(height: 8),
                LiviThemes.spacing.heightSpacer16(),
                notificationInfo(Strings.podInventory,
                    Strings.setYourNotificationPreferences),
                LiviInputField(
                  title: Strings.lowInventoryQuantity,
                  titleStyle: LiviThemes.typography.interMedium_14,
                  focusNode: FocusNode(),
                  controller: quantityController,
                  // onFieldSubmitted: (e) {
                  //   saveUser();
                  // },
                  keyboardType: TextInputType.number,
                ),
                notificationOption(
                  Strings.notifyWhenPodInventoryIsLow,
                  appUser!.inventoryLow,
                  (e) => onChanged(NotificationType.inventoryLow, e, appUser!),
                ),
                notificationOption(
                  Strings.notifyWhenPodInventoryIsEmpty,
                  appUser!.inventoryEmpty,
                  (e) =>
                      onChanged(NotificationType.inventoryEmpty, e, appUser!),
                ),
                notificationOption(
                  Strings.notifyWhenWifiIsUnavailable,
                  appUser!.wifiUnavailable,
                  (e) =>
                      onChanged(NotificationType.wifiUnavailable, e, appUser!),
                ),
                LiviThemes.spacing.heightSpacer16(),
              ],
            );
          }),
    );
  }

  Future<void> onChanged(
      NotificationType notificationType, bool value, AppUser user) async {
    user.setNotification(notificationType, value);
    await appUserService.updateUser(user);
  }

  Future<void> onChangedUseNotification(bool value, AppUser user) async {
    user.usePushNotifications = value;
    await appUserService.updateUser(user);
  }

  Future<void> onChangedUseEmail(bool value, AppUser user) async {
    user.useEmail = value;
    await appUserService.updateUser(user);
  }

  Widget notificationOption(
      String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          LiviTextStyles.interMedium14(title,
              color: LiviThemes.colors.baseBlack),
          Spacer(),
          LiviSwitchButton(
            value: value,
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ],
      ),
    );
  }

  Widget notificationInfo(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LiviTextStyles.interSemiBold14(
            title,
            color: LiviThemes.colors.gray900,
          ),
          LiviTextStyles.interRegular14(
            subtitle,
            color: LiviThemes.colors.gray700,
          ),
        ],
      ),
    );
  }
}
