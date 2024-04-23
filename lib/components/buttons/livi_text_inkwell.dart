import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviTextInkWell extends StatelessWidget {
  final String text;
  final Function() onTap;
  final TextStyle? style;
  const LiviTextInkWell({
    super.key,
    required this.text,
    required this.onTap,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: style ?? LiviThemes.typography.interSemiBold_16,
      ),
    );
  }
}
