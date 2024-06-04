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
    authController.appUser!.lowInventoryQuantity =
        int.parse(quantityController.text);
    await appUserService.updateUser(authController.appUser!);
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
            final user = snapshot.data;
            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: [
                LiviThemes.spacing.heightSpacer16(),
                notificationInfo(
                    Strings.notifications, Strings.stayInformedAboutImportant),
                notificationOption(
                  Strings.appNotification,
                  user.usePushNotifications,
                  (e) => onChangedUseNotification(e, user),
                ),
                notificationOption(
                  Strings.email,
                  user.useEmail,
                  (e) => onChangedUseEmail(e, user),
                ),
                LiviThemes.spacing.heightSpacer8(),
                LiviDivider(height: 8),
                LiviThemes.spacing.heightSpacer16(),
                notificationInfo(Strings.medicationPreferences,
                    Strings.chooseWithNotifications),
                notificationOption(
                  Strings.medicationsAvailable,
                  user.medicationAvailable,
                  (e) =>
                      onChanged(NotificationType.medicationAvailable, e, user),
                ),
                notificationOption(
                  Strings.medicationsLate,
                  user.medicationLate,
                  (e) => onChanged(NotificationType.medicationLate, e, user),
                ),
                notificationOption(
                  Strings.medicationsDue,
                  user.medicationDue,
                  (e) => onChanged(NotificationType.medicationDue, e, user),
                ),
                notificationOption(
                  Strings.medicationsMissed,
                  user.medicationMissed,
                  (e) => onChanged(NotificationType.medicationMissed, e, user),
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
                  user.inventoryLow,
                  (e) => onChanged(NotificationType.inventoryLow, e, user),
                ),
                notificationOption(
                  Strings.notifyWhenPodInventoryIsEmpty,
                  user.inventoryEmpty,
                  (e) => onChanged(NotificationType.inventoryEmpty, e, user),
                ),
                notificationOption(
                  Strings.notifyWhenWifiIsUnavailable,
                  user.wifiUnavailable,
                  (e) => onChanged(NotificationType.wifiUnavailable, e, user),
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
