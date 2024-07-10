import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class BackBar extends StatelessWidget {
  final String? title;
  final EdgeInsets? padding;
  final bool? hasTrailing;
  final Widget? trailing;
  final Function()? onTap;
  final bool? cancelDescription;

  const BackBar(
      {super.key,
      this.title,
      this.padding,
      this.trailing,
      this.cancelDescription = false,
      this.hasTrailing = true,
      this.onTap});

  void pop(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top,
          ),
      child: Row(
        children: [
          _backBar(context),
          if (title != null) Spacer(),
          if (title != null) ...[
            LiviTextStyles.interSemiBold16(title!),
          ],
          if ((hasTrailing ?? false) && trailing != null) ...[
            Spacer(),
            trailing!,
            LiviThemes.spacing.widthSpacer16(),
          ] else ...[
            if (title != null) ...[
              Spacer(),
              _backBar(context, isHidden: true),
            ]
          ]
        ],
      ),
    );
  }

  Widget _backBar(BuildContext context, {bool isHidden = false}) {
    return Opacity(
      opacity: isHidden ? 0 : 1,
      child: Row(
        children: [
          LiviInkWell(
            padding: const EdgeInsets.all(16),
            onTap: isHidden ? () {} : () => pop(context),
            child: LiviThemes.icons.chevroLeftIcon(
                color: cancelDescription == true
                    ? LiviThemes.colors.error600
                    : LiviThemes.colors.brand600),
          ),
          LiviGestureDetector(
            onTap: isHidden ? () {} : () => pop(context),
            child: LiviTextStyles.interRegular16(
                cancelDescription == true ? Strings.cancel : Strings.back,
                color: cancelDescription == true
                    ? LiviThemes.colors.error600
                    : LiviThemes.colors.brand600),
          ),
        ],
      ),
    );
  }
}
