import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

final BorderRadius _borderRadius = BorderRadius.circular(8);

class LiviInputField extends StatefulWidget {
  final String? title;
  final TextStyle? titleStyle;
  final String? subTitle;
  final String? hint;
  final String? errorText;
  final bool readOnly;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final EdgeInsets? padding;
  final String? staticHint;

  final TextEditingController? controller;
  final Widget? prefix;
  final TextCapitalization? textCapitalization;
  final FocusNode focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final Color? color;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final double? topScrollPadding;

  const LiviInputField({
    super.key,
    this.title,
    this.keyboardType = TextInputType.text,
    this.onFieldSubmitted,
    this.errorText,
    this.validator,
    this.onTap,
    this.readOnly = false,
    this.padding,
    this.titleStyle,
    this.textInputAction,
    this.subTitle,
    this.maxLines = 1,
    this.hint,
    this.controller,
    this.prefix,
    required this.focusNode,
    this.onChanged,
    this.textCapitalization,
    this.color,
    this.staticHint,
    this.topScrollPadding,
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
                widget.titleStyle != null
                    ? Text(
                        widget.title!,
                        style: widget.titleStyle,
                      )
                    : LiviTextStyles.interMedium16(widget.title!,
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
              maxLines: widget.maxLines,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              validator: widget.validator,
              onChanged: widget.onChanged,
              scrollPadding: EdgeInsets.only(
                  bottom: double.maxFinite, top: widget.topScrollPadding ?? 0),
              textCapitalization: TextCapitalization.words,
              controller: widget.controller,
              style: LiviThemes.typography.interRegular_16,
              onFieldSubmitted: widget.onFieldSubmitted,
              focusNode: widget.focusNode,
              textInputAction: widget.textInputAction ?? TextInputAction.next,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              decoration: InputDecoration(
                prefixIcon: widget.prefix,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                fillColor: LiviThemes.colors.baseWhite,
                errorMaxLines: 5,
                errorText: widget.errorText,
                border: border(),
                prefix: widget.staticHint != null && widget.focusNode.hasFocus
                    ? LiviTextStyles.interRegular16(widget.staticHint! + ' ',
                        color: LiviThemes.colors.gray400)
                    : null,
                errorBorder: errorBorder(),
                enabledBorder: border(),
                focusedBorder: focusedBorder(),
                errorStyle: LiviThemes.typography.interRegular_12
                    .copyWith(color: LiviThemes.colors.error500),
                disabledBorder: border(),
                focusedErrorBorder: errorBorder(),
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
