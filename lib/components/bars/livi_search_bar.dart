import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviSearchBar extends StatelessWidget {
  final Function(String) onFieldSubmitted;
  final FocusNode focusNode;
  const LiviSearchBar({
    super.key,
    required this.onFieldSubmitted,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return LiviInputField(
      focusNode: focusNode,
      prefix: LiviThemes.icons.searchLgIcon(),
      padding: EdgeInsets.zero,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
