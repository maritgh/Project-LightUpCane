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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `DUTCH`
  String get dutch {
    return Intl.message('DUTCH', name: 'dutch', desc: '', args: []);
  }

  /// `ENGLISH`
  String get english {
    return Intl.message('ENGLISH', name: 'english', desc: '', args: []);
  }

  /// `ON`
  String get on {
    return Intl.message('ON', name: 'on', desc: '', args: []);
  }

  /// `OFF`
  String get off {
    return Intl.message('OFF', name: 'off', desc: '', args: []);
  }

  /// `LOW`
  String get low {
    return Intl.message('LOW', name: 'low', desc: '', args: []);
  }

  /// `MED`
  String get medium {
    return Intl.message('MED', name: 'medium', desc: '', args: []);
  }

  /// `HIGH`
  String get high {
    return Intl.message('HIGH', name: 'high', desc: '', args: []);
  }

  /// `WELCOME TO`
  String get welcome {
    return Intl.message('WELCOME TO', name: 'welcome', desc: '', args: []);
  }

  /// `The app for your Lightup Cane`
  String get app_description {
    return Intl.message(
      'The app for your Lightup Cane',
      name: 'app_description',
      desc: '',
      args: [],
    );
  }

  /// `Move On`
  String get move_on {
    return Intl.message('Move On', name: 'move_on', desc: '', args: []);
  }

  /// `Status`
  String get nav_status {
    return Intl.message('Status', name: 'nav_status', desc: '', args: []);
  }

  /// `Presets`
  String get nav_presets {
    return Intl.message('Presets', name: 'nav_presets', desc: '', args: []);
  }

  /// `Cane\nSettings`
  String get nav_settings_cane {
    return Intl.message(
      'Cane\nSettings',
      name: 'nav_settings_cane',
      desc: '',
      args: [],
    );
  }

  /// `App\nSettings`
  String get nav_settings_app {
    return Intl.message(
      'App\nSettings',
      name: 'nav_settings_app',
      desc: '',
      args: [],
    );
  }

  /// `SUPPORT`
  String get support {
    return Intl.message('SUPPORT', name: 'support', desc: '', args: []);
  }

  /// `APP`
  String get app {
    return Intl.message('APP', name: 'app', desc: '', args: []);
  }

  /// `PRESETS`
  String get presets {
    return Intl.message('PRESETS', name: 'presets', desc: '', args: []);
  }

  /// `CANE SETTINGS`
  String get settings_cane {
    return Intl.message(
      'CANE SETTINGS',
      name: 'settings_cane',
      desc: '',
      args: [],
    );
  }

  /// `APP SETTINGS`
  String get settings_app {
    return Intl.message(
      'APP SETTINGS',
      name: 'settings_app',
      desc: '',
      args: [],
    );
  }

  /// `STATUS`
  String get status {
    return Intl.message('STATUS', name: 'status', desc: '', args: []);
  }

  /// `BATTERY`
  String get battery {
    return Intl.message('BATTERY', name: 'battery', desc: '', args: []);
  }

  /// `LIGHT SETTINGS`
  String get light_settings {
    return Intl.message(
      'LIGHT SETTINGS',
      name: 'light_settings',
      desc: '',
      args: [],
    );
  }

  /// `LIGHT`
  String get light {
    return Intl.message('LIGHT', name: 'light', desc: '', args: []);
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

  /// `HAPTIC`
  String get haptic {
    return Intl.message('HAPTIC', name: 'haptic', desc: '', args: []);
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

  /// `BUZZER`
  String get buzzer {
    return Intl.message('BUZZER', name: 'buzzer', desc: '', args: []);
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

  /// `The Light Up Cane app is an app in which the user can manage the settings of their connected cane. These settings are divided into the pages presets settings cane settings app and status. From every page you have the possibility to go to the previously listed pages.`
  String get explanation_app {
    return Intl.message(
      'The Light Up Cane app is an app in which the user can manage the settings of their connected cane. These settings are divided into the pages presets settings cane settings app and status. From every page you have the possibility to go to the previously listed pages.',
      name: 'explanation_app',
      desc: '',
      args: [],
    );
  }

  /// `The presets page shows the currently saved presets of your app and a save button that allows you to give a name and save all of your current settings under that name. When a preset is selected you get the options to select the settings of that preset delete the preset rename the preset or go back to the preset list.`
  String get explanation_presets {
    return Intl.message(
      'The presets page shows the currently saved presets of your app and a save button that allows you to give a name and save all of your current settings under that name. When a preset is selected you get the options to select the settings of that preset delete the preset rename the preset or go back to the preset list.',
      name: 'explanation_presets',
      desc: '',
      args: [],
    );
  }

  /// `The settings cane page has two subpages and one button, audio light and Find My Cane. On the audio page you can select if you want to receive notifications and you can turn on or off and select the intensities of the haptic and buzzer that are located in the cane. On the light page you can turn the light of the cane on or off and select the intensity of the light. The Find My Cane button can be used to make the cane vibrate and play loud noises in order to easily locate it.`
  String get explanation_settings_cane {
    return Intl.message(
      'The settings cane page has two subpages and one button, audio light and Find My Cane. On the audio page you can select if you want to receive notifications and you can turn on or off and select the intensities of the haptic and buzzer that are located in the cane. On the light page you can turn the light of the cane on or off and select the intensity of the light. The Find My Cane button can be used to make the cane vibrate and play loud noises in order to easily locate it.',
      name: 'explanation_settings_cane',
      desc: '',
      args: [],
    );
  }

  /// `The settings app page has three subpages, theme connection and language. On the theme page you can select themes and accents that will be used throughout the app. On the connection, if your bluetooth is turned on, you can select a cane that you want to connect with. On the language page you can select a language that will be used throught the app.`
  String get explanation_settings_app {
    return Intl.message(
      'The settings app page has three subpages, theme connection and language. On the theme page you can select themes and accents that will be used throughout the app. On the connection, if your bluetooth is turned on, you can select a cane that you want to connect with. On the language page you can select a language that will be used throught the app.',
      name: 'explanation_settings_app',
      desc: '',
      args: [],
    );
  }

  /// `The status page shows the current status of your connected cane, including battery level, light and notifications status, light haptic and buzzer intensities. The information updates every few seconds to keep you up-to-date. Only through the status page can you get to the support page.`
  String get explanation_status {
    return Intl.message(
      'The status page shows the current status of your connected cane, including battery level, light and notifications status, light haptic and buzzer intensities. The information updates every few seconds to keep you up-to-date. Only through the status page can you get to the support page.',
      name: 'explanation_status',
      desc: '',
      args: [],
    );
  }

  /// `CONTACT`
  String get contact {
    return Intl.message('CONTACT', name: 'contact', desc: '', args: []);
  }

  /// `SAVE`
  String get save {
    return Intl.message('SAVE', name: 'save', desc: '', args: []);
  }

  /// `Save New Preset`
  String get save_new_preset {
    return Intl.message(
      'Save New Preset',
      name: 'save_new_preset',
      desc: '',
      args: [],
    );
  }

  /// `Enter Preset Name`
  String get enter_preset_name {
    return Intl.message(
      'Enter Preset Name',
      name: 'enter_preset_name',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get confirm_save {
    return Intl.message('Save', name: 'confirm_save', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `SELECT`
  String get select {
    return Intl.message('SELECT', name: 'select', desc: '', args: []);
  }

  /// `RENAME`
  String get rename {
    return Intl.message('RENAME', name: 'rename', desc: '', args: []);
  }

  /// `Rename Preset`
  String get rename_preset {
    return Intl.message(
      'Rename Preset',
      name: 'rename_preset',
      desc: '',
      args: [],
    );
  }

  /// `Rename`
  String get confirm_rename {
    return Intl.message('Rename', name: 'confirm_rename', desc: '', args: []);
  }

  /// `DELETE`
  String get delete {
    return Intl.message('DELETE', name: 'delete', desc: '', args: []);
  }

  /// `BACK`
  String get back {
    return Intl.message('BACK', name: 'back', desc: '', args: []);
  }

  /// `AUDIO`
  String get audio {
    return Intl.message('AUDIO', name: 'audio', desc: '', args: []);
  }

  /// `AUDIO SETTINGS`
  String get audio_settings {
    return Intl.message(
      'AUDIO SETTINGS',
      name: 'audio_settings',
      desc: '',
      args: [],
    );
  }

  /// `Find My Cane`
  String get find_my_cane {
    return Intl.message(
      'Find My Cane',
      name: 'find_my_cane',
      desc: '',
      args: [],
    );
  }

  /// `LANGUAGE`
  String get language {
    return Intl.message('LANGUAGE', name: 'language', desc: '', args: []);
  }

  /// `CONNECTION`
  String get connection {
    return Intl.message('CONNECTION', name: 'connection', desc: '', args: []);
  }

  /// `Connect`
  String get connect {
    return Intl.message('Connect', name: 'connect', desc: '', args: []);
  }

  /// `connected successfully`
  String get connected_successfully {
    return Intl.message(
      'connected successfully',
      name: 'connected_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth on`
  String get bluetooth_on {
    return Intl.message(
      'Bluetooth on',
      name: 'bluetooth_on',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth off`
  String get bluetooth_off {
    return Intl.message(
      'Bluetooth off',
      name: 'bluetooth_off',
      desc: '',
      args: [],
    );
  }

  /// `Connected Devices`
  String get connected_devices {
    return Intl.message(
      'Connected Devices',
      name: 'connected_devices',
      desc: '',
      args: [],
    );
  }

  /// `Available Devices`
  String get available_devices {
    return Intl.message(
      'Available Devices',
      name: 'available_devices',
      desc: '',
      args: [],
    );
  }

  /// `THEME`
  String get theme {
    return Intl.message('THEME', name: 'theme', desc: '', args: []);
  }

  /// `THEMES`
  String get themes {
    return Intl.message('THEMES', name: 'themes', desc: '', args: []);
  }

  /// `Default System`
  String get default_system {
    return Intl.message(
      'Default System',
      name: 'default_system',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light_theme {
    return Intl.message('Light', name: 'light_theme', desc: '', args: []);
  }

  /// `Dark`
  String get dark_theme {
    return Intl.message('Dark', name: 'dark_theme', desc: '', args: []);
  }

  /// `ACCENTS`
  String get accents {
    return Intl.message('ACCENTS', name: 'accents', desc: '', args: []);
  }

  /// `Red`
  String get red {
    return Intl.message('Red', name: 'red', desc: '', args: []);
  }

  /// `Orange`
  String get orange {
    return Intl.message('Orange', name: 'orange', desc: '', args: []);
  }

  /// `Yellow`
  String get yellow {
    return Intl.message('Yellow', name: 'yellow', desc: '', args: []);
  }

  /// `Green`
  String get green {
    return Intl.message('Green', name: 'green', desc: '', args: []);
  }

  /// `Blue`
  String get blue {
    return Intl.message('Blue', name: 'blue', desc: '', args: []);
  }

  /// `Purple`
  String get purple {
    return Intl.message('Purple', name: 'purple', desc: '', args: []);
  }

  /// `White`
  String get white {
    return Intl.message('White', name: 'white', desc: '', args: []);
  }

  /// `Black`
  String get black {
    return Intl.message('Black', name: 'black', desc: '', args: []);
  }

  /// `LANGUAGES`
  String get languages {
    return Intl.message('LANGUAGES', name: 'languages', desc: '', args: []);
  }
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
