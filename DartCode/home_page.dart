import 'package:flutter/material.dart';
import 'presets_page.dart';
import 'button_page.dart';
import 'settings_page.dart';
import 'status_page.dart';
import 'custom_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // Adjust padding dynamically based on screen width
    double horizontalPadding = screenWidth * 0.1; // 10% of screen width
    double buttonSpacing = screenHeight * 0.05; // 5% of screen height

    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                  color: Colors.black,
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
                    MaterialPageRoute(builder: (context) => PresetsPage()),
                  );
                },
                screenWidth: screenWidth,
                screenHeight: screenHeight,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
