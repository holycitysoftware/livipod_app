import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviSnackBar {
  SnackBar liviSnackBar({
    required String text,
    bool? isError = false,
  }) =>
      SnackBar(
        backgroundColor: isError ?? false
            ? LiviThemes.colors.error200
            : LiviThemes.colors.brand100,
        content: LiviTextStyles.interRegular16(text),
      );
}
