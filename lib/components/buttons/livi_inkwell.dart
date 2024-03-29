import 'dart:async';

import 'package:flutter/material.dart';

class LiviInkWell extends StatelessWidget {
  final Function() onTap;
  final Widget child;
  final Duration debounceDuration;
  const LiviInkWell({
    super.key,
    required this.onTap,
    required this.child,
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
      onTap: handleTap,
      child: child,
    );
  }
}
