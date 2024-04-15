import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../../utils/timezones.dart';
import '../components.dart';

class LiviInputField extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final EdgeInsets? padding;
  final TextEditingController? controller;
  final Widget? prefix;

  const LiviInputField({
    super.key,
    required this.title,
    this.keyboardType,
    this.errorText,
    this.padding,
    this.subTitle,
    this.hint,
    this.controller,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LiviTextStyles.interMedium16(title,
                  color: LiviThemes.colors.baseBlack),
              LiviThemes.spacing.widthSpacer4(),
              if (subTitle != null && subTitle!.isNotEmpty)
                LiviTextStyles.interMedium16(subTitle!,
                    color: LiviThemes.colors.baseBlack),
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
              controller: controller,
              keyboardType: keyboardType ?? TextInputType.text,
              decoration: InputDecoration(
                prefix: prefix,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                fillColor: LiviThemes.colors.baseWhite,
                errorText: errorText,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: LiviThemes.colors.gray300,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: hint,
                hintStyle: LiviThemes.typography.interRegular_16
                    .copyWith(color: LiviThemes.colors.gray400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
