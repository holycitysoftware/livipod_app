import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class CheckPersonaCard extends StatelessWidget {
  final String option;
  final bool isSelected;
  final Function() onTap;
  const CheckPersonaCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
            color: LiviThemes.colors.baseWhite,
            border: Border.all(color: LiviThemes.colors.gray200),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: LiviThemes.colors.brand600.withOpacity(0.24),
                spreadRadius: 3.0,
                blurRadius: 2,
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: LiviTextStyles.interSemiBold16(option)),
            LiviThemes.spacing.widthSpacer32(),
            Opacity(
                opacity: isSelected ? 1 : 0,
                child: LiviThemes.icons.checkIcon()),
          ],
        ),
      ),
    );
  }
}
