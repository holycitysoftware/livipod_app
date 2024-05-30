import 'package:flutter/cupertino.dart';

import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class LiviAlertDialog {
  void empty() {}
  // This shows a C upertinoModalPopup which hosts a CupertinoAlertDialog.
  static Future<void> showAlertDialog(BuildContext context) async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: LiviTextStyles.interSemiBold17(Strings.alert),
        content: LiviTextStyles.interRegular14(
            Strings.areYouSureYouWantToLogout,
            color: LiviThemes.colors.dayMaster100),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: LiviTextStyles.interRegular17(Strings.cancel,
                color: LiviThemes.colors.dayBrand100),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: LiviTextStyles.interRegular17(Strings.logout,
                color: LiviThemes.colors.error600),
          ),
        ],
      ),
    );
  }

  static Future<bool> removeCaregiver(BuildContext context, String name) async {
    var remove = false;
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: LiviTextStyles.interSemiBold17(Strings.removeCaregiver),
        content: LiviTextStyles.interRegular14(
            '${Strings.areYouSureYouWantToRemove} $name ${Strings.willNoLongerHaveAccess}',
            color: LiviThemes.colors.dayMaster100),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: LiviTextStyles.interRegular17(Strings.cancel,
                color: LiviThemes.colors.dayBrand100),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              remove = true;
            },
            child: LiviTextStyles.interRegular17(Strings.remove,
                color: LiviThemes.colors.error600),
          ),
        ],
      ),
    );
    return remove;
  }
}
