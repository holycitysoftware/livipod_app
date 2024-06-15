import 'package:flutter/material.dart';

import '../components.dart';

class LiviPillInfo extends StatelessWidget {
  final String text;
  final Color iconColor;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  const LiviPillInfo({
    super.key,
    required this.text,
    required this.iconColor,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            size: 6,
            color: iconColor,
          ),
          const SizedBox(width: 8),
          LiviTextStyles.interMedium14(text, color: textColor),
        ],
      ),
    );
  }
}
