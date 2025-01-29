// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accents": MessageLookupByLibrary.simpleMessage("ACCENTS"),
    "app": MessageLookupByLibrary.simpleMessage("APP"),
    "app_description": MessageLookupByLibrary.simpleMessage(
      "The app for your Lightup Cane",
    ),
    "audio": MessageLookupByLibrary.simpleMessage("AUDIO"),
    "audio_settings": MessageLookupByLibrary.simpleMessage("AUDIO SETTINGS"),
    "available_devices": MessageLookupByLibrary.simpleMessage(
      "Available Devices",
    ),
    "back": MessageLookupByLibrary.simpleMessage("BACK"),
    "battery": MessageLookupByLibrary.simpleMessage("BATTERY"),
    "black": MessageLookupByLibrary.simpleMessage("Black"),
    "blue": MessageLookupByLibrary.simpleMessage("Blue"),
    "bluetooth_off": MessageLookupByLibrary.simpleMessage("Bluetooth off"),
    "bluetooth_on": MessageLookupByLibrary.simpleMessage("Bluetooth on"),
    "buzzer": MessageLookupByLibrary.simpleMessage("BUZZER"),
    "buzzer_intensity": MessageLookupByLibrary.simpleMessage(
      "BUZZER INTENSITY",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "confirm_rename": MessageLookupByLibrary.simpleMessage("Rename"),
    "confirm_save": MessageLookupByLibrary.simpleMessage("Save"),
    "connected_devices": MessageLookupByLibrary.simpleMessage(
      "Connected Devices",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("CONNECTION"),
    "contact": MessageLookupByLibrary.simpleMessage("CONTACT"),
    "dark_theme": MessageLookupByLibrary.simpleMessage("Dark"),
    "default_system": MessageLookupByLibrary.simpleMessage("Default System"),
    "delete": MessageLookupByLibrary.simpleMessage("DELETE"),
    "dutch": MessageLookupByLibrary.simpleMessage("DUTCH"),
    "english": MessageLookupByLibrary.simpleMessage("ENGLISH"),
    "enter_preset_name": MessageLookupByLibrary.simpleMessage(
      "Enter Preset Name",
    ),
    "explanation_app": MessageLookupByLibrary.simpleMessage(
      "The Light Up Cane app is an app in which the user can manage the settings of their connected cane. These settings are divided into the pages presets settings cane settings app and status. From every page you have the possibility to go to the previously listed pages.",
    ),
    "explanation_presets": MessageLookupByLibrary.simpleMessage(
      "The presets page shows the currently saved presets of your app and a save button that allows you to give a name and save all of your current settings under that name. When a preset is selected you get the options to select the settings of that preset delete the preset rename the preset or go back to the preset list.",
    ),
    "explanation_settings_app": MessageLookupByLibrary.simpleMessage(
      "The settings app page has three subpages, theme connection and language. On the theme page you can select themes and accents that will be used throughout the app. On the connection, if your bluetooth is turned on, you can select a cane that you want to connect with. On the language page you can select a language that will be used throught the app.",
    ),
    "explanation_settings_cane": MessageLookupByLibrary.simpleMessage(
      "The settings cane page has two subpages and one button, audio light and Find My Cane. On the audio page you can select if you want to receive notifications and you can turn on or off and select the intensities of the haptic and buzzer that are located in the cane. On the light page you can turn the light of the cane on or off and select the intensity of the light. The Find My Cane button can be used to make the cane vibrate and play loud noises in order to easily locate it.",
    ),
    "explanation_status": MessageLookupByLibrary.simpleMessage(
      "The status page shows the current status of your connected cane, including battery level, light and notifications status, light haptic and buzzer intensities. The information updates every few seconds to keep you up-to-date. Only through the status page can you get to the support page.",
    ),
    "find_my_cane": MessageLookupByLibrary.simpleMessage("Find My Cane"),
    "green": MessageLookupByLibrary.simpleMessage("Green"),
    "haptic": MessageLookupByLibrary.simpleMessage("HAPTIC"),
    "haptic_intensity": MessageLookupByLibrary.simpleMessage(
      "HAPTIC INTENSITY",
    ),
    "high": MessageLookupByLibrary.simpleMessage("HIGH"),
    "language": MessageLookupByLibrary.simpleMessage("LANGUAGE"),
    "languages": MessageLookupByLibrary.simpleMessage("LANGUAGES"),
    "light": MessageLookupByLibrary.simpleMessage("LIGHT"),
    "light_intensity": MessageLookupByLibrary.simpleMessage("LIGHT INTENSITY"),
    "light_settings": MessageLookupByLibrary.simpleMessage("LIGHT SETTINGS"),
    "light_theme": MessageLookupByLibrary.simpleMessage("Light"),
    "low": MessageLookupByLibrary.simpleMessage("LOW"),
    "medium": MessageLookupByLibrary.simpleMessage("MED"),
    "move_on": MessageLookupByLibrary.simpleMessage("Move On"),
    "nav_presets": MessageLookupByLibrary.simpleMessage("Presets"),
    "nav_settings_app": MessageLookupByLibrary.simpleMessage("App\nSettings"),
    "nav_settings_cane": MessageLookupByLibrary.simpleMessage("Cane\nSettings"),
    "nav_status": MessageLookupByLibrary.simpleMessage("Status"),
    "notifications": MessageLookupByLibrary.simpleMessage("NOTIFICATIONS"),
    "off": MessageLookupByLibrary.simpleMessage("OFF"),
    "on": MessageLookupByLibrary.simpleMessage("ON"),
    "orange": MessageLookupByLibrary.simpleMessage("Orange"),
    "presets": MessageLookupByLibrary.simpleMessage("PRESETS"),
    "purple": MessageLookupByLibrary.simpleMessage("Purple"),
    "red": MessageLookupByLibrary.simpleMessage("Red"),
    "rename": MessageLookupByLibrary.simpleMessage("RENAME"),
    "rename_preset": MessageLookupByLibrary.simpleMessage("Rename Preset"),
    "save": MessageLookupByLibrary.simpleMessage("SAVE"),
    "save_new_preset": MessageLookupByLibrary.simpleMessage("Save New Preset"),
    "select": MessageLookupByLibrary.simpleMessage("SELECT"),
    "settings_app": MessageLookupByLibrary.simpleMessage("APP SETTINGS"),
    "settings_cane": MessageLookupByLibrary.simpleMessage("CANE SETTINGS"),
    "status": MessageLookupByLibrary.simpleMessage("STATUS"),
    "support": MessageLookupByLibrary.simpleMessage("SUPPORT"),
    "theme": MessageLookupByLibrary.simpleMessage("THEME"),
    "themes": MessageLookupByLibrary.simpleMessage("THEMES"),
    "welcome": MessageLookupByLibrary.simpleMessage("WELCOME TO"),
    "white": MessageLookupByLibrary.simpleMessage("White"),
    "yellow": MessageLookupByLibrary.simpleMessage("Yellow"),
  };
}