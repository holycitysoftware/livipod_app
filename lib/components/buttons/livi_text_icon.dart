import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class LiviTextIcon extends StatelessWidget {
  final Function() onPressed;
  const LiviTextIcon({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Row(
        children: [
          LiviTextStyles.interMedium16(Strings.addNew,
              color: LiviThemes.colors.brand600),
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 8),
            child: LiviThemes.icons.plusIcon(),
          )
        ],
      ),
    );
  }
}
