import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class LiviDivider extends StatelessWidget {
  final Color? color;
  final double? height;
  const LiviDivider({
    super.key,
    this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? LiviThemes.colors.gray200,
      height: height ?? 1,
      width: double.maxFinite,
    );
  }
}
