import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';
import '../widgets/bounding_card.dart';

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
//TODO:add borders here
  @override
  Widget build(BuildContext context) {
    return BoundingCard(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: LiviTextStyles.interSemiBold16(option)),
          LiviThemes.spacing.widthSpacer32(),
          if (isSelected) LiviThemes.icons.checkIcon(),
        ],
      ),
    );
  }
}
