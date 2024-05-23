import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../themes/livi_themes.dart';
import '../../utils/utils.dart';
import '../text/livi_text_styles.dart';

class NameCircleBox extends StatelessWidget {
  final AppUser appUser;
  final bool isSmaller;
  const NameCircleBox({
    super.key,
    required this.appUser,
    this.isSmaller = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LiviThemes.colors.gray400,
        shape: BoxShape.circle,
        border: Border.all(color: LiviThemes.colors.gray400),
      ),
      child: isSmaller
          ? LiviTextStyles.interSemiBold14(
              getFirstLettersOfName(appUser),
              color: LiviThemes.colors.baseWhite,
              textAlign: TextAlign.center,
            )
          : LiviTextStyles.interSemiBold36(
              getFirstLettersOfName(appUser),
              color: LiviThemes.colors.baseWhite,
              textAlign: TextAlign.center,
            ),
    );
  }
}
