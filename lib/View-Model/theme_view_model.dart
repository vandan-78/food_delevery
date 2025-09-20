import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ThemeViewModel extends ChangeNotifier{
//   bool _isDark = false;
//   bool get isDark => _isDark;
//
//   ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;
//
//   void toggleTheme(){
//     _isDark = !_isDark;
//     notifyListeners();
//   }
//
//
// }
// StateNotifier holds state of type bool (isDark or not)

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light); // initial state

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

// Provider for ThemeNotifier
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});