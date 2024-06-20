import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviOutlinedButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  const LiviOutlinedButton({
    super.key,
    required this.onTap,
    this.width,
    this.borderColor,
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
          overlayColor: textColor != null
              ? MaterialStatePropertyAll(textColor!.withOpacity(.1))
              : null,
          backgroundColor: MaterialStatePropertyAll(
              backgroundColor ?? LiviThemes.colors.baseWhite),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: borderColor ?? LiviThemes.colors.gray300),
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
