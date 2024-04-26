//custom app bar code
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../themes/livi_themes.dart';

class LiviAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onPressed;
  const LiviAppBar({
    super.key,
    required this.title,
    this.onPressed,
  });

  @override
  State<LiviAppBar> createState() => _LiviAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);
}

class _LiviAppBarState extends State<LiviAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      // leading: BackBar(),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: LiviThemes.colors.brand600,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: LiviTextStyles.interSemiBold16(widget.title),
      actions: widget.onPressed != null
          ? [LiviTextIcon(onPressed: widget.onPressed!)]
          : null,
    );
  }
}
