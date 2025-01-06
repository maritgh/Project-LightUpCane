// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `DUTCH`
  String get dutch {
    return Intl.message(
      'DUTCH',
      name: 'dutch',
      desc: '',
      args: [],
    );
  }

  /// `ENGLISH`
  String get english {
    return Intl.message(
      'ENGLISH',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `STATUS`
  String get status {
    return Intl.message(
      'STATUS',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `BATTERY`
  String get battery {
    return Intl.message(
      'BATTERY',
      name: 'battery',
      desc: '',
      args: [],
    );
  }

  /// `LIGHT`
  String get light {
    return Intl.message(
      'LIGHT',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `LIGHT INTENSITY`
  String get light_intensity {
    return Intl.message(
      'LIGHT INTENSITY',
      name: 'light_intensity',
      desc: '',
      args: [],
    );
  }

  /// `NOTIFICATIONS`
  String get notifications {
    return Intl.message(
      'NOTIFICATIONS',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `HAPTIC INTENSITY`
  String get haptic_intensity {
    return Intl.message(
      'HAPTIC INTENSITY',
      name: 'haptic_intensity',
      desc: '',
      args: [],
    );
  }

  /// `BUZZER INTENSITY`
  String get buzzer_intensity {
    return Intl.message(
      'BUZZER INTENSITY',
      name: 'buzzer_intensity',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the '' key
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'nl'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
