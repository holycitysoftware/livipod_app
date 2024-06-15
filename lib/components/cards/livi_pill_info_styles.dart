import 'dart:ui';

import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class LiviPillInfoStyles {
  LiviPillInfoStyles._();

  static LiviPillInfo late() => LiviPillInfo(
        backgroundColor: LiviThemes.colors.error50,
        text: Strings.late,
        iconColor: LiviThemes.colors.error500,
        textColor: LiviThemes.colors.error700,
        borderColor: LiviThemes.colors.error200,
      );

  static LiviPillInfo due() => LiviPillInfo(
        backgroundColor: LiviThemes.colors.randomBlue3,
        text: Strings.due,
        iconColor: LiviThemes.colors.blue500,
        textColor: LiviThemes.colors.randomBlue,
        borderColor: LiviThemes.colors.randomBlue2,
      );

  static LiviPillInfo early() => LiviPillInfo(
        backgroundColor: LiviThemes.colors.error50,
        text: Strings.late,
        iconColor: LiviThemes.colors.error500,
        textColor: LiviThemes.colors.error700,
        borderColor: LiviThemes.colors.error200,
      );
}
