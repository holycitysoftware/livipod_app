import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class IconBoundingCard extends StatelessWidget {
  final Widget child;
  const IconBoundingCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: LiviThemes.colors.gray200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
