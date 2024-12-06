import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'my_app.dart';
import 'theme_provider.dart';
import 'notification_provider.dart';

void main() async {
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

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           themeMode: themeProvider.themeMode,
//           theme: ThemeData(
//             brightness: Brightness.light,
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: themeProvider.accentColor,
//               brightness: Brightness.light,
//             ),
//           ),
//           darkTheme: ThemeData(
//             brightness: Brightness.dark,
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: themeProvider.accentColor,
//               brightness: Brightness.dark,
//             ),
//           ),
//           debugShowCheckedModeBanner: false,
//           home: HomePage(),
//         );
//       },
//     );
//   }
// }
