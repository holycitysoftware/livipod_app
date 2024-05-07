import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class LiviTextIcon extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final Widget icon;
  final bool enabled;
  const LiviTextIcon({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Row(
        children: [
          LiviTextStyles.interMedium16(text,
              color: enabled
                  ? LiviThemes.colors.brand600
                  : LiviThemes.colors.gray400),
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 8),
            child: icon,
          )
        ],
      ),
    );
  }
}
