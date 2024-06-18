import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class TextIconHomeButton extends StatelessWidget {
  final Function() onTap;
  final bool isExpanded;
  final List<Widget> children;
  const TextIconHomeButton({
    super.key,
    required this.onTap,
    required this.isExpanded,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: LiviThemes.colors.baseWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: LiviThemes.colors.gray200,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}
