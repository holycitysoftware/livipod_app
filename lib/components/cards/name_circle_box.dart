import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../../utils/utils.dart';
import '../text/livi_text_styles.dart';

class NameCircleBox extends StatelessWidget {
  final String name;
  final bool isSmaller;
  const NameCircleBox({
    super.key,
    required this.name,
    this.isSmaller = false,
  });

  Widget getLetters() {
    if (name.isNotEmpty) {
      if (isSmaller) {
        return LiviTextStyles.interSemiBold14(
          getFirstLettersOfName(name),
          color: LiviThemes.colors.baseWhite,
          textAlign: TextAlign.center,
        );
      } else {
        return LiviTextStyles.interSemiBold36(
          getFirstLettersOfName(name),
          color: LiviThemes.colors.baseWhite,
          textAlign: TextAlign.center,
        );
      }
    } else {
      if (isSmaller) {
        return LiviTextStyles.interSemiBold14(
          '',
          color: LiviThemes.colors.baseWhite,
          textAlign: TextAlign.center,
        );
      } else {
        return LiviTextStyles.interSemiBold36(
          '',
          color: LiviThemes.colors.baseWhite,
          textAlign: TextAlign.center,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isSmaller ? 40 : 80,
      width: isSmaller ? 40 : 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: LiviThemes.colors.gray400,
        shape: BoxShape.circle,
        border: Border.all(color: LiviThemes.colors.gray400),
      ),
      child: getLetters(),
    );
  }
}
