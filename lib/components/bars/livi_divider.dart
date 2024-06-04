import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class LiviDivider extends StatelessWidget {
  final Color? color;
  final double? height;
  final bool? isVertical;
  const LiviDivider({
    super.key,
    this.color,
    this.isVertical = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? LiviThemes.colors.gray200,
      height: isVertical ?? false ? double.maxFinite : height ?? 1,
      width: isVertical ?? false ? 1 : double.maxFinite,
    );
  }
}
