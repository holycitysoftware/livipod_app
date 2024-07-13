import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class BoundingCard extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  final bool? isSelected;
  const BoundingCard({
    super.key,
    required this.child,
    this.onTap,
    this.isSelected = false,
  });
  List<BoxShadow>? boxShadow() {
    if (isSelected == true) {
      return [
        BoxShadow(
            color: LiviThemes.colors.brand600.withOpacity(0.24),
            spreadRadius: 2,
            blurRadius: 1),
      ];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap ?? () {},
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          boxShadow: boxShadow(),
          color: LiviThemes.colors.baseWhite,
          border: Border.all(color: LiviThemes.colors.gray200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}
