import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class IconCircleBox extends StatelessWidget {
  const IconCircleBox({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.color,
    this.padding,
    this.onTap,
  });
  final Widget child;
  final double? height;
  final Function()? onTap;
  final Color? color;
  final double? width;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Ink(
        padding: padding ?? EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color ?? LiviThemes.colors.brand600,
          borderRadius: BorderRadius.circular(64),
        ),
        child: child,
      ),
    );
  }
}
