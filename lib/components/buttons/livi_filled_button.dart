import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviFilledButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? margin;
  final bool showArrow;
  const LiviFilledButton({
    super.key,
    required this.text,
    this.margin,
    required this.onTap,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          maximumSize: MaterialStatePropertyAll(
            Size(double.infinity, 48),
          ),
          minimumSize: MaterialStatePropertyAll(
            Size(double.infinity, 48),
          ),
          backgroundColor: MaterialStatePropertyAll(LiviThemes.colors.brand600),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LiviTextStyles.interSemiBold18(text,
                color: LiviThemes.colors.baseWhite),
            LiviThemes.spacing.widthSpacer8(),
            if (showArrow) LiviThemes.icons.arrowNarrowright
          ],
        ),
      ),
    );
  }
}
