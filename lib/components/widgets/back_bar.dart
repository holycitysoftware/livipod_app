import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class BackBar extends StatelessWidget {
  final String? title;
  final EdgeInsets? padding;

  const BackBar({super.key, this.title, this.padding});

  void pop(BuildContext context) {
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
          if (title != null) LiviTextStyles.interSemiBold16(title!),
          if (title != null) Spacer(),
          _backBar(context, isHidden: true),
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
            child: LiviThemes.icons.chevronLeft,
          ),
          LiviGestureDetector(
            onTap: isHidden ? () {} : () => pop(context),
            child: LiviTextStyles.interRegular16(Strings.back,
                color: LiviThemes.colors.brand600),
          ),
        ],
      ),
    );
  }
}
