//custom app bar code
import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';

class LiviAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onPressed;
  final bool backButton;
  final List<Widget>? tail;
  final double? elevation;
  final Widget? mainWidget;
  final Color? color;
  final bool? cancelDescription;
  const LiviAppBar({
    super.key,
    required this.title,
    this.onPressed,
    this.mainWidget,
    this.elevation,
    this.color,
    this.cancelDescription = false,
    this.backButton = false,
    this.tail,
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
      foregroundColor: widget.color ?? LiviThemes.colors.baseWhite,
      backgroundColor: widget.color ?? LiviThemes.colors.baseWhite,
      shadowColor: LiviThemes.colors.baseWhite,
      elevation: widget.elevation ?? 0, centerTitle: true,
      surfaceTintColor: LiviThemes.colors.baseWhite,
      leading: widget.backButton ||
              (ModalRoute.of(context)?.impliesAppBarDismissal ?? false)
          ? BackBar(
              cancelDescription: widget.cancelDescription,
            )
          : null,
      leadingWidth: 90,
      // leading: IconButton(
      //   icon: Icon(
      //     Icons.arrow_back_ios,
      //     color: LiviThemes.colors.brand600,
      //   ),
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      // ),
      title: widget.mainWidget ??
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: LiviTextStyles.interSemiBold16(widget.title,
                textAlign: TextAlign.center),
          ),
      actions: widget.onPressed != null
          ? widget.tail ??
              [
                LiviTextIcon(
                  onPressed: widget.onPressed!,
                  icon: LiviThemes.icons.plusIcon(),
                  text: Strings.addNew,
                ),
              ]
          : null,
    );
  }
}
