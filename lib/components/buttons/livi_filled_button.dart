import 'dart:io';

import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviFilledButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final EdgeInsets? margin;
  final bool showArrow;
  final bool? isCloseToNotch;
  final bool isLoading;
  final Color? color;
  final bool? enabled;
  final Color? textColor;
  final Color? borderColor;

  const LiviFilledButton({
    super.key,
    required this.text,
    this.margin,
    required this.onTap,
    this.color,
    this.enabled = true,
    this.textColor,
    this.borderColor,
    this.isLoading = false,
    this.isCloseToNotch = false,
    this.showArrow = false,
  });

  bool get isButtonCloseToNotch => Platform.isIOS && (isCloseToNotch ?? false);

  BorderSide border() {
    if (enabled == false && borderColor == null) {
      return BorderSide(color: LiviThemes.colors.gray200);
    }
    if (borderColor != null) {
      return BorderSide(color: borderColor!);
    }
    return BorderSide.none;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: isButtonCloseToNotch ? 32 : 0),
      child: ElevatedButton(
        style: ButtonStyle(
          surfaceTintColor:
              MaterialStatePropertyAll(LiviThemes.colors.baseWhite),
          foregroundColor: MaterialStatePropertyAll(textColor),
          overlayColor: MaterialStatePropertyAll(textColor?.withOpacity(.1)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: border(),
            ),
          ),
          maximumSize: MaterialStatePropertyAll(
            Size(double.infinity, 48),
          ),
          minimumSize: MaterialStatePropertyAll(
            Size(double.infinity, 48),
          ),
          backgroundColor: color != null
              ? MaterialStatePropertyAll(color)
              : MaterialStatePropertyAll(enabled ?? false
                  ? LiviThemes.colors.brand600
                  : LiviThemes.colors.gray100),
        ),
        onPressed: ((enabled ?? false) && !isLoading) ? onTap : null,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LiviTextStyles.interSemiBold16(text,
                      color: textColor ??
                          ((enabled ?? false)
                              ? LiviThemes.colors.baseWhite
                              : LiviThemes.colors.gray400)),
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
