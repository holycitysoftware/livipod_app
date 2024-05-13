import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class IconBoundingBox extends StatelessWidget {
  const IconBoundingBox({
    super.key,
    required this.child,
    this.height,
    this.width,
    this.color,
    this.padding,
  });
  final Widget child;
  final double? height;
  final Color? color;
  final double? width;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 28,
      width: width ?? 28,
      padding: padding ?? EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color ?? LiviThemes.colors.brand600,
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}
