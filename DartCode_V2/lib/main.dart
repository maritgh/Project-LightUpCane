import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'my_app.dart';
import 'theme_provider.dart';
import 'notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: MyApp(),
    ),
  );
}


// in pubspec.yaml change dependecies into below to make it work
// dependencies:
//  flutter:
//    sdk: flutter
//   provider: ^6.0.0
//   flutter_blue_plus: ^1.34.4
//   http: ^1.2.2
//   flutter_tts: ^4.1.0
//   hive: ^2.2.3
//   hive_flutter: ^1.1.0 
//   flutter_localizations:
//     sdk: flutter
//   intl: ^0.19.0
//   intl_utils: ^2.8.7
//   permission_handler: ^11.3.1
