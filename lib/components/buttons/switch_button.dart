import 'package:flutter/material.dart';

class LiviSwitchButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const LiviSwitchButton({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .7,
      alignment: Alignment.centerRight,
      child: Switch(value: value, onChanged: onChanged),
    );
  }
}
