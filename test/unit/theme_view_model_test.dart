import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:newspulse/features/settings/presentation/theme_view_model.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> settingsBox;

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('hive_theme_test_');
    Hive.init(tempDir.path);
    settingsBox = await Hive.openBox<dynamic>('test_settings');
  });

  tearDown(() async {
    await settingsBox.close();
    await Hive.deleteBoxFromDisk('test_settings');
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('ThemeViewModel Persistence', () {
    test('defaults to ThemeMode.system when box is empty', () {
      final viewModel = ThemeViewModel(settingsBox: settingsBox);
      expect(viewModel.themeMode, ThemeMode.system);
    });

    test('persists dark mode and loads it after reopen', () async {
      final viewModel = ThemeViewModel(settingsBox: settingsBox);
      await viewModel.setThemeMode(ThemeMode.dark);
      expect(viewModel.themeMode, ThemeMode.dark);

      await settingsBox.close();

      final reopenedBox = await Hive.openBox<dynamic>('test_settings');
      final newViewModel = ThemeViewModel(settingsBox: reopenedBox);
      expect(newViewModel.themeMode, ThemeMode.dark);
      await reopenedBox.close();
    });
  });
}
