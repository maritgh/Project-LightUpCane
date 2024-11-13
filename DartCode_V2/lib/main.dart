import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_app.dart';
import 'theme_provider.dart';
import 'notification_provider.dart';

void main() {
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
