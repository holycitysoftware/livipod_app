import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../text/livi_text_styles.dart';

class LiviTextButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? margin;
  const LiviTextButton({
    super.key,
    this.margin,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        child: LiviTextStyles.interSemiBold18(text,
            color: LiviThemes.colors.brand600),
      ),
    );
  }
}
