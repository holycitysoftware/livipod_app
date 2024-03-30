import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import 'livi_text_component.dart';

class LiviTextStyles {
  LiviTextStyles._();

  static LiviTextComponent interSemiBold18({
    required String data,
    Color? color,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
    double? height,
    TextDecoration? lineThrough,
    EdgeInsets? margin,
  }) =>
      LiviTextComponent(
        data: data,
        color: color,
        maxLines: maxLines,
        margin: margin,
        overflow: overflow,
        textStyle: LiviThemes.typography.interSemiBold_18.copyWith(
          height: height,
          decoration: lineThrough ?? TextDecoration.none,
        ),
        textAlign: textAlign,
      );

  static LiviTextComponent interSemiBold24({
    required String data,
    Color? color,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
    double? height,
    TextDecoration? lineThrough,
    EdgeInsets? margin,
  }) =>
      LiviTextComponent(
        data: data,
        color: color,
        maxLines: maxLines,
        margin: margin,
        overflow: overflow,
        textStyle: LiviThemes.typography.interSemiBold_24.copyWith(
          height: height,
          decoration: lineThrough ?? TextDecoration.none,
        ),
        textAlign: textAlign,
      );
}
