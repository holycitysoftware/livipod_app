import 'package:flutter/material.dart';

import '../components.dart';

class LiviFilledButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  const LiviFilledButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: LiviTextStyles.interSemiBold18(data: text),
    );
  }
}
