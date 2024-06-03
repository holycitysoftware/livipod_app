import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class LiviOutlinedButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  const LiviOutlinedButton({
    super.key,
    required this.onTap,
    this.width,
    required this.text,
    this.textColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 90,
      height: 35,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
              backgroundColor ?? LiviThemes.colors.baseWhite),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: LiviThemes.colors.gray300),
            ),
          ),
        ),
        onPressed: onTap,
        child: LiviTextStyles.interSemiBold14(text,
            color: textColor ?? LiviThemes.colors.gray700),
      ),
    );
  }
}
