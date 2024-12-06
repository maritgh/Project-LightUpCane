import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = Colors.purple;

  // Hive box for storing settings
  final Box _settingsBox = Hive.box('settings');

  ThemeProvider() {
    // Load settings from Hive during initialization
    _themeMode = _getThemeModeFromHive();
    _accentColor = _getAccentColorFromHive();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;

  // Setters
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();

    // Save to Hive
    _settingsBox.put('themeMode', _themeMode.index);
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    notifyListeners();

    // Save to Hive
    _settingsBox.put('accentColor', color.value);
  }

  // Helper methods to read from Hive
  ThemeMode _getThemeModeFromHive() {
    final int themeIndex = _settingsBox.get('themeMode', defaultValue: ThemeMode.system.index);
    return ThemeMode.values[themeIndex];
  }

  Color _getAccentColorFromHive() {
    final int colorValue = _settingsBox.get('accentColor', defaultValue: Colors.purple.value);
    return Color(colorValue);
  }
}


//in pubspec.yaml change dependecies into below to make it work
//dependencies:
//  flutter:
//    sdk: flutter
//  provider: ^6.0.0 