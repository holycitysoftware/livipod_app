import 'package:flutter/material.dart';

import '../../themes/livi_themes.dart';
import '../components.dart';

class LiviTextIcon extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final Widget icon;
  final bool enabled;
  final bool loading;
  const LiviTextIcon({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.loading = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      overlayColor: MaterialStatePropertyAll(
        LiviThemes.colors.brand600.withOpacity(0.1),
      ),
      onTap: onPressed,
      child: loading
          ? Container(
              alignment: Alignment.center,
              height: 20,
              width: 20,
              margin: EdgeInsets.only(right: 12),
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  LiviTextStyles.interMedium16(text,
                      color: enabled
                          ? LiviThemes.colors.brand600
                          : LiviThemes.colors.gray400),
                  Padding(
                    padding: const EdgeInsets.only(left: 2, right: 8),
                    child: icon,
                  )
                ],
              ),
            ),
    );
  }
}
