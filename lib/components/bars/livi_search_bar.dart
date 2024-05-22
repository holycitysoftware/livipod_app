import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../../utils/strings.dart';
import '../components.dart';

class LiviSearchBar extends StatefulWidget {
  final Function(String)? onFieldSubmitted;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final Function()? onTap;
  const LiviSearchBar({
    super.key,
    this.onTap,
    this.onFieldSubmitted,
    required this.focusNode,
    required this.controller,
    this.onChanged,
  });

  @override
  State<LiviSearchBar> createState() => _LiviSearchBarState();
}

class _LiviSearchBarState extends State<LiviSearchBar> {
  @override
  void initState() {
    widget.focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LiviInputField(
      onTap: () => widget.onTap,
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      controller: widget.controller,
      color: widget.focusNode.hasFocus
          ? LiviThemes.colors.baseWhite
          : LiviThemes.colors.gray200,
      prefix: Padding(
        padding: const EdgeInsets.all(16),
        child: LiviThemes.icons.searchLgIcon(color: LiviThemes.colors.gray500),
      ),
      hint: Strings.searchByName,
      padding: EdgeInsets.zero,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
