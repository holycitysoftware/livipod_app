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
      child: Theme(
        data: ThemeData(
          // accentColor: LiviThemes.colors.brand600,
          toggleButtonsTheme: ToggleButtonsThemeData(
            color: LiviThemes.colors.gray100,
            borderColor: LiviThemes.colors.transparent,
            selectedColor: LiviThemes.colors.baseWhite,
            fillColor: LiviThemes.colors.brand600,
            focusColor: LiviThemes.colors.brand600,
            hoverColor: LiviThemes.colors.brand600,
            highlightColor: LiviThemes.colors.brand600,
            splashColor: LiviThemes.colors.brand600,
            borderWidth: 0,
            disabledBorderColor: LiviThemes.colors.transparent,
            selectedBorderColor: LiviThemes.colors.brand600,
            borderRadius: BorderRadius.circular(30),
          ),
          // toggleableActiveColor: LiviThemes.colors.brand600,
        ),
        child: Switch(
          value: value,
          onChanged: onChanged,
          // inactiveThumbColor: LiviThemes.colors.baseWhite,
          // inactiveTrackColor: LiviThemes.colors.gray100,
          // activeColor: LiviThemes.colors.brand600,
          // thumbColor: MaterialStatePropertyAll(LiviThemes.colors.baseWhite),
          // trackColor: MaterialStatePropertyAll(LiviThemes.colors.gray100),
          // focusColor: LiviThemes.colors.brand600,
          // hoverColor: LiviThemes.colors.brand600,
          // overlayColor: MaterialStateProperty.all(LiviThemes.colors.green700),
        ),
      ),
    );
  }
}
