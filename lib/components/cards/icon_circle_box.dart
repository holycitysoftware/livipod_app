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
    this.tapPadding,
  });
  final Widget child;
  final EdgeInsets? tapPadding;
  final double? height;
  final Function()? onTap;
  final Color? color;
  final double? width;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: tapPadding ?? EdgeInsets.zero,
        child: Ink(
          padding: padding ?? EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color ?? LiviThemes.colors.brand600,
            borderRadius: BorderRadius.circular(64),
          ),
          child: child,
        ),
      ),
    );
  }
}
