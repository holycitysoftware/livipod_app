import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

final BorderRadius _borderRadius = BorderRadius.circular(8);

class LiviInputField extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final String? hint;
  final String? errorText;
  final bool readOnly;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final EdgeInsets? padding;
  final TextEditingController? controller;
  final Widget? prefix;
  final TextCapitalization? textCapitalization;
  final FocusNode focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final Color? color;

  const LiviInputField({
    super.key,
    this.title,
    this.keyboardType = TextInputType.text,
    this.onFieldSubmitted,
    this.errorText,
    this.onTap,
    this.readOnly = false,
    this.padding,
    this.subTitle,
    this.hint,
    this.controller,
    this.prefix,
    required this.focusNode,
    this.textCapitalization,
    this.color,
  });

  @override
  State<LiviInputField> createState() => _LiviInputFieldState();
}

class _LiviInputFieldState extends State<LiviInputField> {
  @override
  void initState() {
    widget.focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  InputBorder focusedBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: LiviThemes.colors.brand300,
      ),
      borderRadius: _borderRadius,
    );
  }

  InputBorder border() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: LiviThemes.colors.gray300,
      ),
      borderRadius: _borderRadius,
    );
  }

  InputBorder errorBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: LiviThemes.colors.error300,
      ),
      borderRadius: _borderRadius,
    );
  }

  List<BoxShadow>? boxShadow() {
    if (!widget.focusNode.hasFocus &&
        widget.errorText != null &&
        widget.errorText!.isNotEmpty) {
      return [];
    } else if (widget.focusNode.hasFocus && widget.errorText == null) {
      return [
        BoxShadow(
          color: LiviThemes.colors.brand600.withOpacity(0.24),
          spreadRadius: 3.0,
        ),
      ];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.title != null)
                LiviTextStyles.interMedium16(widget.title!,
                    color: LiviThemes.colors.gray500),
              LiviThemes.spacing.widthSpacer4(),
              if (widget.subTitle != null && widget.subTitle!.isNotEmpty)
                LiviTextStyles.interMedium16(widget.subTitle!,
                    color: LiviThemes.colors.gray500),
            ],
          ),
          LiviThemes.spacing.heightSpacer6(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color ?? Colors.white,
              borderRadius: _borderRadius,
              boxShadow: boxShadow(),
            ),
            child: TextFormField(
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              scrollPadding: EdgeInsets.only(bottom: double.maxFinite),
              textCapitalization: TextCapitalization.words,
              controller: widget.controller,
              style: LiviThemes.typography.interRegular_16,
              onFieldSubmitted: widget.onFieldSubmitted,
              focusNode: widget.focusNode,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: widget.prefix,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                fillColor: LiviThemes.colors.baseWhite,
                errorMaxLines: 5,
                errorText: widget.errorText,
                border: border(),
                errorBorder: errorBorder(),
                enabledBorder: border(),
                focusedBorder: focusedBorder(),
                disabledBorder: border(),
                focusedErrorBorder: border(),
                hintText: widget.hint,
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
