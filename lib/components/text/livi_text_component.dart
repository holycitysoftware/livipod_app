import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class LiviTextComponent extends StatelessWidget {
  final String? data;
  final Color? color;
  final TextStyle? textStyle;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final EdgeInsets? margin;

  const LiviTextComponent({
    super.key,
    required this.data,
    this.color,
    this.textStyle,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: Text(
        data!,
        style: textStyle != null
            ? textStyle!.copyWith(color: color ?? LiviThemes.colors.baseBlack)
            : TextStyle(color: LiviThemes.colors.baseBlack),
        overflow: overflow,
        maxLines: maxLines,
        textAlign: textAlign,
      ),
    );
  }
}
