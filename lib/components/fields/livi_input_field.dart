import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../../utils/timezones.dart';
import '../components.dart';

final BorderRadius _borderRadius = BorderRadius.circular(8);

class LiviInputField extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final EdgeInsets? padding;
  final TextEditingController? controller;
  final Widget? prefix;
  final TextCapitalization? textCapitalization;
  final FocusNode focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  const LiviInputField({
    super.key,
    required this.title,
    this.keyboardType = TextInputType.text,
    this.onFieldSubmitted,
    this.errorText,
    this.padding,
    this.subTitle,
    this.hint,
    this.controller,
    this.prefix,
    required this.focusNode,
    this.textCapitalization,
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
          TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: controller,
            onFieldSubmitted: onFieldSubmitted,
            focusNode: focusNode,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: prefix,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              fillColor: LiviThemes.colors.baseWhite,
              errorMaxLines: 2,
              errorText: errorText,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: LiviThemes.colors.brand600,
                ),
                borderRadius: _borderRadius,
              ),
              hintText: hint,
              hintStyle: LiviThemes.typography.interRegular_16
                  .copyWith(color: LiviThemes.colors.gray400),
            ),
          ),
        ],
      ),
    );
  }
}
