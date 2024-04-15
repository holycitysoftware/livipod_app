import 'package:flutter/material.dart';
import 'package:iphone_has_notch/iphone_has_notch.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviFilledButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? margin;
  final bool showArrow;
  final bool? isCloseToNotch;
  final bool? isLoading;
  final bool? enabled;

  const LiviFilledButton({
    super.key,
    required this.text,
    this.margin,
    required this.onTap,
    this.enabled = true,
    this.isLoading = false,
    this.isCloseToNotch = false,
    this.showArrow = false,
  });

  bool get isButtonCloseToNotch =>
      IphoneHasNotch.hasNotch && (isCloseToNotch ?? false);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: isButtonCloseToNotch ? 16 : 0),
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
          backgroundColor: MaterialStatePropertyAll(enabled ?? false
              ? LiviThemes.colors.brand600
              : LiviThemes.colors.gray200),
        ),
        onPressed: (enabled ?? false) ? onTap : null,
        child: (isLoading ?? false)
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LiviTextStyles.interSemiBold18(text,
                      color: (enabled ?? false)
                          ? LiviThemes.colors.baseWhite
                          : LiviThemes.colors.gray400),
                  LiviThemes.spacing.widthSpacer8(),
                  if (showArrow)
                    (enabled ?? false)
                        ? LiviThemes.icons.arrowNarrowright
                        : LiviThemes.icons.arrowNarrowrightGray
                ],
              ),
      ),
    );
  }
}
