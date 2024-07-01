import 'package:flutter/material.dart';

class ValueListenables {
  static final ValueListenables instance = ValueListenables._internal();

  factory ValueListenables() => instance;

  ValueListenables._internal();

  static final ValueNotifier<int> _cardHeight = ValueNotifier(0);

  ValueNotifier<int> get cardHeight => _cardHeight;
}
