import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_button.dart';
import 'theme_page.dart';
import 'connection_page.dart';
import 'language_page.dart';
import 'theme_provider.dart';
import 'bottom_nav_bar.dart'; // Import your BottomNavBar

class SettingsAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Get screen dimensions for dynamic scaling
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // Adjust padding and spacing dynamically based on screen size
    double horizontalPadding = screenWidth * 0.1; // 10% padding
    double buttonSpacing = screenHeight * 0.05; // Spacing between buttons

    // Define the dynamic color based on the theme, required for THEME and CONNECTION to adjust theme
    Color dynamicColor = themeProvider.themeMode == ThemeMode.dark
        ? Colors.grey[850]!
        : Colors.grey[400]!;

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.grey[800] // Dark background for dark theme
          : Colors.grey[300], // Light background for light theme
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Settings App Title
                  Center(
                    child: Container(
                      width: screenWidth * 0.8,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.grey[850]
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(20), // Rounded corners for the header
                      ),
                      child: Center(
                        child: Text(
                          'SETTINGS APP',
                          style: TextStyle(
                            color: themeProvider.accentColor, // Use accent color from ThemeProvider
                            fontSize: screenWidth * 0.08, // Dynamic font size based on screen width
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: buttonSpacing * 3), // Space between title and buttons

                  // Theme Button
                  CustomButton(
                    label: 'THEME',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThemePage()),
                      );
                    },
                    screenWidth: screenWidth, // Pass screen dimensions for dynamic sizing
                    screenHeight: screenHeight,
                    color: dynamicColor, // Use accent color from ThemeProvider
                  ),
                  SizedBox(height: buttonSpacing), // Spacing between buttons

                  // Connection Button
                  CustomButton(
                    label: 'CONNECTION',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConnectionPage()),
                      );
                    },
                    screenWidth: screenWidth, // Pass screen dimensions for dynamic sizing
                    screenHeight: screenHeight,
                    color: dynamicColor, // Use accent color from ThemeProvider
                  ),
                  SizedBox(height: buttonSpacing), // Spacing between buttons

                  // Connection Button
                  CustomButton(
                    label: 'LANGUAGE',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LanguagePage()),
                      );
                    },
                    screenWidth: screenWidth, // Pass screen dimensions for dynamic sizing
                    screenHeight: screenHeight,
                    color: dynamicColor, // Use accent color from ThemeProvider
                  ),
                  SizedBox(height: buttonSpacing), // Spacing between buttons

                  Spacer(), // Push content up to make space for bottom navigation bar

                  SizedBox(height: buttonSpacing),
                ],
              );
            },
          ),
        ),
      ),
      // Add the BottomNavBar with the currentPage set to "SettingsApp"
      bottomNavigationBar: BottomNavBar(currentPage: "SettingsApp"),
    );
  }
}
