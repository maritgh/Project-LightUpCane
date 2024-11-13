import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  bool _notifications = false;

  bool get notifications => _notifications;

  set notifications(bool value) {
    if (value != _notifications) {
      _notifications = value;
      notifyListeners();
    }
  }

  void toggleNotifications() {
    _notifications = !_notifications;
    notifyListeners();
  }
}