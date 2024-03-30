import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviInputField extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? hint;
  final TextInputType? keyboardType;

  const LiviInputField({
    super.key,
    required this.title,
    this.keyboardType,
    this.subTitle,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            LiviTextStyles.interMedium16(title),
            LiviThemes.spacing.widthSpacer4(),
            if (subTitle != null && subTitle!.isNotEmpty)
              LiviTextStyles.interRegular14(subTitle!,
                  color: LiviThemes.colors.gray500),
          ],
        ),
        LiviThemes.spacing.heightSpacer6(),
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: LiviThemes.colors.gray900.withOpacity(0.05),
              blurRadius: 15,
              offset: Offset(0, 7),
            ),
          ]),
          child: TextFormField(
            keyboardType: keyboardType ?? TextInputType.text,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              fillColor: LiviThemes.colors.baseWhite,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: LiviThemes.colors.gray300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: hint,
              hintStyle: LiviThemes.typography.interRegular_16,
            ),
          ),
        ),
      ],
    );
  }
}
