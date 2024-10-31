import 'package:flutter/material.dart';
import 'my_app.dart';
//added
import 'package:provider/provider.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

// original
//void main() {
//  runApp(MyApp());
//}
