import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';

class LiviPodWidget extends StatelessWidget {
  const LiviPodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 105,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: LiviThemes.colors.baseBlack.withOpacity(0),
              blurRadius: 48,
              offset: Offset(0, 171),
            ),
            BoxShadow(
              color: LiviThemes.colors.baseBlack.withOpacity(0.01),
              blurRadius: 44,
              offset: Offset(0, 110),
            ),
            BoxShadow(
              color: LiviThemes.colors.baseBlack.withOpacity(0.05),
              blurRadius: 37,
              offset: Offset(0, 62),
            ),
            BoxShadow(
              color: LiviThemes.colors.baseBlack.withOpacity(0.09),
              blurRadius: 27,
              offset: Offset(0, 27),
            ),
            BoxShadow(
              color: LiviThemes.colors.baseBlack.withOpacity(0.1),
              blurRadius: 15,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: LiviThemes.icons.liviPodImage);
  }
}
