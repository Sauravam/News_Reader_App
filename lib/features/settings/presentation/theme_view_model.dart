import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class ThemeViewModel extends ChangeNotifier {
  final Box<dynamic> settingsBox;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeViewModel({required this.settingsBox}) {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadThemeMode() {
    final savedMode = settingsBox.get('themeMode') as String?;
    if (savedMode == 'light') {
      _themeMode = ThemeMode.light;
    } else if (savedMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final modeString = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await settingsBox.put('themeMode', modeString);
    notifyListeners();
  }
}
