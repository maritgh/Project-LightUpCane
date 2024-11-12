import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_button.dart';
import 'theme_provider.dart';
import 'status_page.dart'; // Import StatusPage

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Access ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.light
          ? Colors.grey[300]
          : Colors.black87, // Dynamic background color based on theme
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Welcome Text
              Text(
                'WELKOM BIJ',
                style: TextStyle(
                  color: themeProvider.themeMode == ThemeMode.light
                      ? Colors.black
                      : Colors.white, // Dynamic text color based on theme
                  fontSize: screenWidth * 0.12,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.02),
              
              // App Name Text
              Text(
                'LIGHTUP CANE',
                style: TextStyle(
                  color: themeProvider.themeMode == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: screenWidth * 0.10,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.15),
              
              // Description Text
              Text(
                'De app voor jouw Lightup Cane',
                style: TextStyle(
                  color: themeProvider.themeMode == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: screenWidth * 0.06,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.2),
              
              // Return Button (Navigates to StatusPage)
              CustomButton(
                label: 'Verder gaan',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatusPage()),
                  );
                },
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                color: themeProvider.accentColor, // Dynamic accent color from ThemeProvider
              ),
            ],
          ),
        ),
      ),
    );
  }
}
