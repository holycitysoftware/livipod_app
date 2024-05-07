import 'dart:io';

import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';
import '../text/livi_text_styles.dart';

class LiviTextButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? margin;
  final bool? isCloseToNotch;
  final Color? color;
  final Widget? icon;
  const LiviTextButton({
    super.key,
    this.margin,
    this.isCloseToNotch = false,
    required this.text,
    required this.onTap,
    this.color,
    this.icon,
  });

  bool isButtonCloseToNotch() {
    return Platform.isIOS && (isCloseToNotch ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isButtonCloseToNotch() ? 16 : 0),
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onTap,
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          maximumSize: MaterialStatePropertyAll(
            Size(double.infinity, 52),
          ),
          minimumSize: MaterialStatePropertyAll(
            Size(double.infinity, 52),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null) icon!,
          LiviTextStyles.interSemiBold16(
            text,
            color: color ?? LiviThemes.colors.brand600,
          ),
        ]),
      ),
    );
  }
}
