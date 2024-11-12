import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'theme_page.dart'; // (luc1 needs to be changed, was required for Rae's project)
import 'presets_page.dart';
import 'button_page.dart';
import 'settings_page.dart';
import 'status_page.dart';
import 'custom_button.dart';
import 'theme_provider.dart'; // Import your ThemeProvider

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // Adjust padding dynamically based on screen width
    double horizontalPadding = screenWidth * 0.1; // 10% of screen width
    double buttonSpacing = screenHeight * 0.05; // 5% of screen height

    // Access ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.light
          ? Colors.grey[300]
          : Colors.black87, // Change based on theme mode
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Button
              Container(
                width: screenWidth * 0.2, // 20% of screen width
                height: screenWidth * 0.2, // Maintain square aspect ratio
                decoration: BoxDecoration(
                  color: themeProvider.accentColor, // Use accent color from provider
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'LOGO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05, // 5% of screen width
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.08), // Space between logo and buttons

              // Presets Button
              CustomButton(
                label: "PRESETS",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThemePage()), //Temporary themepage FIX THIS TO CORRECT PAGE LATER)
                  );
                },
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                color: themeProvider.accentColor, // Use accent color
              ),

              SizedBox(height: buttonSpacing), // Space between buttons

              // Button Button
              CustomButton(
                label: "BUTTON",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ButtonPage()),
                  );
                },
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                color: themeProvider.accentColor, // Use accent color
              ),

              SizedBox(height: buttonSpacing), // Space between buttons

              // Settings Button
              CustomButton(
                label: "SETTINGS",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                color: themeProvider.accentColor, // Use accent color
              ),

              SizedBox(height: buttonSpacing), // Space between buttons

              // Status Button
              CustomButton(
                label: "STATUS",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatusPage()),
                  );
                },
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                color: themeProvider.accentColor, // Use accent color
              ),
            ],
          ),
        ),
      ),
    );
  }
}