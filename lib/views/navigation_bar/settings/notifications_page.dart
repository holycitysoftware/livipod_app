import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
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

  var appNotification = true;
  var email = false;
  var medicationsAvailable = false;
  var medicationsLate = false;
  var medicationsDue = true;
  var medicationsMissed = true;
  var notifyWhenPodInventoryIsLow = false;
  var notifyWhenPodInventoryIsEmpty = false;
  var notifyWhenWifiIsUnavailable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LiviThemes.colors.baseWhite,
      appBar: LiviAppBar(
        title: Strings.notificationsSettings,
      ),
      body: ListView(
        children: [
          LiviThemes.spacing.heightSpacer16(),
          notificationInfo(
              Strings.notifications, Strings.stayInformedAboutImportant),
          notificationOption(
            Strings.appNotification,
            appNotification,
            (e) => onChanged(appNotification, e),
          ),
          notificationOption(
            Strings.email,
            email,
            (e) => onChanged(email, e),
          ),
          LiviDivider(height: 8),
          LiviThemes.spacing.heightSpacer16(),
          notificationInfo(
              Strings.medicationPreferences, Strings.chooseWithNotifications),
          notificationOption(
            Strings.medicationsAvailable,
            medicationsAvailable,
            (e) => onChanged(medicationsAvailable, e),
          ),
          notificationOption(
            Strings.medicationsLate,
            medicationsLate,
            (e) => onChanged(medicationsLate, e),
          ),
          notificationOption(
            Strings.medicationsDue,
            medicationsDue,
            (e) => onChanged(medicationsDue, e),
          ),
          notificationOption(
            Strings.medicationsMissed,
            medicationsMissed,
            (e) => onChanged(medicationsMissed, e),
          ),
          LiviDivider(height: 8),
          LiviThemes.spacing.heightSpacer16(),
          notificationInfo(
              Strings.podInventory, Strings.setYourNotificationPreferences),
          LiviInputField(
            title: Strings.quantity,
            titleStyle: LiviThemes.typography.interMedium_14,
            focusNode: FocusNode(),
            controller: quantityController,
            keyboardType: TextInputType.number,
          ),
          notificationOption(
            Strings.notifyWhenPodInventoryIsLow,
            notifyWhenPodInventoryIsLow,
            (e) => onChanged(notifyWhenPodInventoryIsLow, e),
          ),
          notificationOption(
            Strings.notifyWhenPodInventoryIsEmpty,
            notifyWhenPodInventoryIsEmpty,
            (e) => onChanged(notifyWhenPodInventoryIsEmpty, e),
          ),
          notificationOption(
            Strings.notifyWhenWifiIsUnavailable,
            notifyWhenWifiIsUnavailable,
            (e) => onChanged(notifyWhenWifiIsUnavailable, e),
          ),
        ],
      ),
    );
  }

  void onChanged(bool variable, bool value) {
    setState(() {
      variable = value;
    });
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
            value: true,
            onChanged: (value) {},
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
