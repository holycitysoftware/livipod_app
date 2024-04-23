import 'package:flutter/material.dart';
import 'package:iphone_has_notch/iphone_has_notch.dart';
import 'package:livipod_app/utils/strings.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';
import '../text/livi_text_styles.dart';

class LiviTextButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? margin;
  final bool? isCloseToNotch;
  const LiviTextButton({
    super.key,
    this.margin,
    this.isCloseToNotch = false,
    required this.text,
    required this.onTap,
  });

  bool isButtonCloseToNotch() {
    return IphoneHasNotch.hasNotch && (isCloseToNotch ?? false);
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
        child: LiviTextInkWell(
          text: text,
          onTap: () {},
          style: LiviThemes.typography.interSemiBold_16.copyWith(
            color: LiviThemes.colors.brand600,
          ),
        ),
      ),
    );
  }
}
