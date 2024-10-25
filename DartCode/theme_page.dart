import 'package:flutter/material.dart';

void main() {
  runApp(ThemePage());
}

class ThemePage extends StatefulWidget {
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  ThemeMode _themeMode = ThemeMode.system; // Default to system theme
  Color accentColor = Colors.purple; // Default accent color

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _setAccentColor(Color color) {
    setState(() {
      accentColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Theme Setting'),
        ),
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THEMES',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    // Default system theme button
                    fullWidthButton('Default System', () => _setThemeMode(ThemeMode.system), _themeMode == ThemeMode.system ? accentColor : Colors.grey),
                    // Light theme button
                    fullWidthButton('Light', () => _setThemeMode(ThemeMode.light), _themeMode == ThemeMode.light ? accentColor : Colors.grey),
                    // Dark theme button
                    fullWidthButton('Dark', () => _setThemeMode(ThemeMode.dark), _themeMode == ThemeMode.dark ? accentColor : Colors.grey),

                    SizedBox(height: 20),
                    Text(
                      'ACCENTS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                    // Accent color buttons
                    // Adjust colors as needed for future projects
                    accentButton('Red', Colors.red),
                    accentButton('Orange', Colors.orange),
                    accentButton('Yellow', Colors.yellow),
                    accentButton('Green', Colors.green),
                    accentButton('Blue', Colors.blue),
                    accentButton('Purple', Colors.purple),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to generate accent color buttons with full width
  Widget accentButton(String label, Color color) {
    return fullWidthButton(
      label,
          () => _setAccentColor(color),
      accentColor == color ? accentColor : Colors.grey,
    );
  }

  // Helper method to create full-width buttons
  Widget fullWidthButton(String label, VoidCallback onPressed, Color textColor) {
    return SizedBox(
      width: double.infinity, // Makes the button expand to full width
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0), // Adds padding to the button
          alignment: Alignment.centerLeft, // Aligns the text to the left
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
