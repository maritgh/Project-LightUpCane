import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:luc1/theme_provider.dart'; // Import ThemeProvider
import 'custom_button.dart'; // Import CustomButton

class ThemePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider

    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Setting'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to HomePage
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0), // Padding for the title section
            child: Text(
              'THEMES',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
          // Full-width buttons for theme selection
          fullWidthButton(
            'Default System',
                () => themeProvider.setThemeMode(ThemeMode.system),
            themeProvider.themeMode == ThemeMode.system ? themeProvider.accentColor : Colors.grey,
          ),
          fullWidthButton(
            'Light',
                () => themeProvider.setThemeMode(ThemeMode.light),
            themeProvider.themeMode == ThemeMode.light ? themeProvider.accentColor : Colors.grey,
          ),
          fullWidthButton(
            'Dark',
                () => themeProvider.setThemeMode(ThemeMode.dark),
            themeProvider.themeMode == ThemeMode.dark ? themeProvider.accentColor : Colors.grey,
          ),
          SizedBox(height: 20), // Space between themes and accents
          Padding(
            padding: const EdgeInsets.all(8.0), // Padding for the accents section
            child: Text(
              'ACCENTS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
          // Accent color buttons
          accentButton('Red', Colors.redAccent, themeProvider),
          accentButton('Orange', Colors.orangeAccent, themeProvider),
          accentButton('Yellow', Colors.yellowAccent, themeProvider),
          accentButton('Green', Colors.greenAccent, themeProvider),
          accentButton('Blue', Colors.blueAccent, themeProvider),
          accentButton('Purple', Colors.purpleAccent, themeProvider),
        ],
      ),
    );
  }

  // Helper method to generate accent color buttons with full width
  Widget accentButton(String label, Color color, ThemeProvider themeProvider) {
    return fullWidthButton(
      label,
          () => themeProvider.setAccentColor(color),
      themeProvider.accentColor == color ? themeProvider.accentColor : Colors.grey,
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
