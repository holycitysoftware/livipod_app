import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviFilledButtonWhite extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? margin;
  final Color? textColor;
  const LiviFilledButtonWhite({
    super.key,
    required this.text,
    this.margin,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStatePropertyAll(0),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide(
                color: LiviThemes.colors.gray300,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maximumSize: MaterialStatePropertyAll(
            Size(double.infinity, 48),
          ),
          minimumSize: MaterialStatePropertyAll(
            Size(double.infinity, 48),
          ),
          backgroundColor:
              MaterialStatePropertyAll(LiviThemes.colors.baseWhite),
        ),
        onPressed: onTap,
        child: LiviTextStyles.interSemiBold16(text,
            color: textColor ?? LiviThemes.colors.brand600),
      ),
    );
  }
}
