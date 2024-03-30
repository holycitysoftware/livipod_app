import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviFilledButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? margin;
  const LiviFilledButton({
    super.key,
    required this.text,
    this.margin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maximumSize: WidgetStateProperty.all(
            Size(double.infinity, 48),
          ),
          minimumSize: WidgetStateProperty.all(
            Size(double.infinity, 48),
          ),
          backgroundColor: WidgetStateProperty.all(LiviThemes.colors.brand600),
        ),
        onPressed: onTap,
        child: LiviTextStyles.interSemiBold18(text,
            color: LiviThemes.colors.baseWhite),
      ),
    );
  }
}
