import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationProvider extends ChangeNotifier {
  bool _notifications = false;
  bool _haptic = true;
  double _hapticIntensity = 25.0;
  bool _buzzer = true;
  double _buzzerIntensity = 75.0;
  String _lightIntensity = '30';
  bool _light = false;

  final Box _settingsBox = Hive.box('settings');

  NotificationProvider() {
    // Load states from Hive
    _notifications = _settingsBox.get('notifications', defaultValue: false);
    _haptic = _settingsBox.get('haptic', defaultValue: true);
    _hapticIntensity = _settingsBox.get('hapticIntensity', defaultValue: 25.0);
    _buzzer = _settingsBox.get('buzzer', defaultValue: true);
    _buzzerIntensity = _settingsBox.get('buzzerIntensity', defaultValue: 75.0);
    _lightIntensity = _settingsBox.get('lightIntensity', defaultValue: '30');   
    _light = _settingsBox.get('light', defaultValue: false);
  }

  bool get notifications => _notifications;
  bool get haptic => _haptic;
  double get hapticIntensity => _hapticIntensity;
  bool get buzzer => _buzzer;
  double get buzzerIntensity => _buzzerIntensity;
  String get lightIntensity => _lightIntensity;
  bool get light => _light;

  void setNotifications(bool value) {
    if (value != _notifications) {
      _notifications = value;
      _settingsBox.put('notifications', value);
      notifyListeners();
    }
  }

  void setHaptic(bool value) {
    if (_haptic != value) {
      _haptic = value;
      _settingsBox.put('haptic', value);
      notifyListeners();
    }
  }
  
  void setHapticIntensity(double value) {
    if (_hapticIntensity != value) {
      _hapticIntensity = value;
      _settingsBox.put('hapticIntensity', value);
      notifyListeners();
    }
  }
  
  void setBuzzer(bool value) {
    if (_buzzer != value) {
      _buzzer = value;
      _settingsBox.put('buzzer', value);
      notifyListeners();
    }
  }

  void setBuzzerIntensity(double value) {
    if (_buzzerIntensity != value) {
      _buzzerIntensity = value;
      _settingsBox.put('buzzerIntensity', value);
      notifyListeners();
    }
  }

  void setLightIntensity(String value) {
    if (_lightIntensity != value) {
      _lightIntensity = value;
      _settingsBox.put('lightIntensity', value);
      notifyListeners();
    }
  }

  void setLight(bool value) {
    if (_light != value) {
      _light = value;
      _settingsBox.put('light', value);
      notifyListeners();
    }
  }
}  