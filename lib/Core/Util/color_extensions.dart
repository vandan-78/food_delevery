// utils/color_extensions.dart
import 'package:flutter/material.dart';

extension ColorOpacityExtension on Color {
  Color withOpacity(double opacity) {
    return withValues(
      red: red.toDouble() * opacity,
      green: green.toDouble() * opacity,
      blue: blue.toDouble() * opacity,
      alpha: alpha.toDouble() * opacity,
    );
  }
}