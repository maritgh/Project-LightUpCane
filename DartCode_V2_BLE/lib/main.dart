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


// dependencies:
//   flutter:
//     sdk: flutter
//   flutter_blue_plus: ^1.34.5
//   flutter_tts: ^4.2.0
//   hive_flutter: ^1.1.0
//   http: ^1.2.2
//   permission_handler: ^11.3.1
//   provider: ^6.1.2
//   intl: ^0.19.0
//   flutter_local_notifications: ^18.0.1
//   flutter_localizations: 
//     sdk: flutter
//   intl_utils: ^2.8.7

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
