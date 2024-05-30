import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class LiviSwitchButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const LiviSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .7,
      alignment: Alignment.centerRight,
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        // inactiveThumbColor: LiviThemes.colors.error500,
        // activeTrackColor: LiviThemes.colors.error500,
        // inactiveTrackColor: LiviThemes.colors.gray100,
        activeColor: LiviThemes.colors.brand600,
        // thumbColor: MaterialStatePropertyAll(LiviThemes.colors.baseWhite),
        // trackColor: MaterialStatePropertyAll(
        //     value ? LiviThemes.colors.brand600 : LiviThemes.colors.gray100),
        // focusColor: LiviThemes.colors.brand600,
        // hoverColor: LiviThemes.colors.brand600,
        // trackOutlineColor: MaterialStatePropertyAll(LiviThemes.colors.gray100),
        // overlayColor: MaterialStateProperty.all(LiviThemes.colors.brand600),
      ),
    );
  }
}
