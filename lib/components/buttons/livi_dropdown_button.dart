import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviDropdownButton<T> extends StatelessWidget {
  final ValueChanged<T?>? onChanged;
  final List<DropdownMenuItem<T>>? items;
  final T? value;
  final bool isExpanded;
  final String? hint;
  const LiviDropdownButton({
    super.key,
    required this.onChanged,
    required this.items,
    this.hint,
    this.value,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: LiviThemes.colors.gray300),
      ),
      child: DropdownButton<T>(
        underline: SizedBox(),
        padding: EdgeInsets.only(left: 16, right: 8),
        style: LiviThemes.typography.interRegular_16
            .copyWith(color: LiviThemes.colors.baseBlack),
        menuMaxHeight: 320,
        borderRadius: BorderRadius.circular(8),
        icon: LiviThemes.icons.chevronDownGray,
        value: value,
        elevation: 16,
        hint: hint != null ? LiviTextStyles.interRegular16(hint!) : null,
        onChanged: onChanged,
        isExpanded: isExpanded,
        items: items,
      ),
    );
  }
}
