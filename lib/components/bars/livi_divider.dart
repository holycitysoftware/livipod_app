import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class LiviDivider extends StatelessWidget {
  final Color? color;
  const LiviDivider({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? LiviThemes.colors.gray200,
      height: 1,
      width: double.maxFinite,
    );
  }
}
