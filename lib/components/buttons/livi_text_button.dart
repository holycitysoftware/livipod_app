import 'package:flutter/material.dart';

import '../text/livi_text_styles.dart';

class LiviTextButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  const LiviTextButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: LiviTextStyles.interSemiBold18(data: text),
    );
  }
}
