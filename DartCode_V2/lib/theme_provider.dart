import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = Colors.purple;
  Locale _locale = Locale('nl'); // Default to Dutch

  // Hive box for storing settings
  final Box _settingsBox = Hive.box('settings');

  ThemeProvider() {
    // Load settings from Hive during initialization
    _themeMode = _getThemeModeFromHive();
    _accentColor = _getAccentColorFromHive();
    _locale = _getLocaleFromHive();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  Locale get locale => _locale;

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

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();

    // Save to Hive
    _settingsBox.put('locale', locale.languageCode);
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

  Locale _getLocaleFromHive() {
    final String languageCode = _settingsBox.get('locale', defaultValue: 'nl');
    return Locale(languageCode);
  }
}
