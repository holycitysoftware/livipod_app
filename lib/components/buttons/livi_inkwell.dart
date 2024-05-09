import 'dart:async';

import 'package:flutter/material.dart';

class LiviInkWell extends StatelessWidget {
  final Function() onTap;
  final Widget child;
  final EdgeInsets? padding;
  final Duration debounceDuration;
  final double borderRadius;
  const LiviInkWell({
    super.key,
    required this.onTap,
    this.padding,
    required this.child,
    this.borderRadius = 64,
    this.debounceDuration = const Duration(milliseconds: 2000),
  });

  @override
  Widget build(BuildContext context) {
    bool isProcessing = false;
    Timer debounceTimer;

    void handleTap() {
      if (isProcessing) {
        return;
      }

      isProcessing = true;
      onTap();

      debounceTimer = Timer(debounceDuration, () {
        isProcessing = false;
      });
    }

    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
