import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class LiviTextIcon extends StatelessWidget {
  const LiviTextIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LiviTextStyles.interRegular16(Strings.addNew,
            color: LiviThemes.colors.brand600),
        LiviThemes.icons.plus
      ],
    );
  }
}
