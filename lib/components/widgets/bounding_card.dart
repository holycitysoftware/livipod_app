import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class BoundingCard extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  const BoundingCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap ?? () {},
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: LiviThemes.colors.gray200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}
