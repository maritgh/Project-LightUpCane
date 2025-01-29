import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'custom_button.dart';
import 'audio_page.dart';
import 'theme_provider.dart'; // Import your ThemeProvider

class SettingsPage extends StatelessWidget {
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

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.black87 // Dark background for dark theme
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
                  // Settings Title
                  Center(
                    child: Container(
                      width: screenWidth * 0.8,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                      decoration: BoxDecoration(
                        color: themeProvider.accentColor, // Use accent color from ThemeProvider
                        borderRadius: BorderRadius.circular(20), // Rounded corners for the header
                      ),
                      child: Center(
                        child: Text(
                          'SETTINGS',
                          style: TextStyle(
                            color: themeProvider.accentColor == Colors.white ? Colors.black : Colors.white, // adjusts the text color only if the accent color is white
                            fontSize: screenWidth * 0.08, // Dynamic font size based on screen width
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: buttonSpacing * 3), // Space between title and buttons

                  // Audio Button
                  CustomButton(
                    label: 'AUDIO',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AudioPage()),
                      );
                    },
                    screenWidth: screenWidth, // Pass screen dimensions for dynamic sizing
                    screenHeight: screenHeight,
                    color: themeProvider.accentColor, // Use accent color from ThemeProvider
                  ),
                  SizedBox(height: buttonSpacing), // Spacing between buttons

                  // Light Button
                  CustomButton(
                    label: 'LIGHT',
                    onPressed: () {
                      // Add light functionality here
                    },
                    screenWidth: screenWidth, // Pass screen dimensions for dynamic sizing
                    screenHeight: screenHeight,
                    color: themeProvider.accentColor, // Use accent color from ThemeProvider
                  ),
                  SizedBox(height: buttonSpacing), // Spacing between buttons

                  Spacer(), // Push the return button to the bottom of the page

                  // Return Button
                  CustomButton(
                    label: 'RETURN',
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to previous page
                    },
                    screenWidth: screenWidth, // Pass screen dimensions for dynamic sizing
                    screenHeight: screenHeight,
                    color: themeProvider.accentColor, // Use accent color from ThemeProvider
                  ),
                  SizedBox(height: buttonSpacing), // Same bottom spacing as in StatusPage
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
