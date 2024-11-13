import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'bottom_nav_bar.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

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
          ? Colors.black87
          : Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Support Title
              Center(
                child: Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                  decoration: BoxDecoration(
                    color: themeProvider.accentColor,
                    borderRadius: BorderRadius.circular(20), // Rounded corners for title
                  ),
                  child: Center(
                    child: Text(
                      'SUPPORT',
                      style: TextStyle(
                        color: themeProvider.accentColor == Colors.white ? Colors.black : Colors.white, // adjusts the text color only if the accent color is white
                        fontSize: screenWidth * 0.07, // Dynamic font size based on screen width
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: buttonSpacing), // Space between header and buttons

              // Support Options (APP, PRESETS, SETTINGS, STATUS)
              _buildSupportOption('APP', Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption('PRESETS', Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption('SETTINGS CANE', Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption('SETTINGS APP', Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption('STATUS', Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons

              // Contact Option at the bottom
              _buildContactOption('CONTACT', Icons.phone, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Spacing before the return button
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentPage: "Support"),
    );
  }

  // Method to build each support option row (App, Presets, etc.)
  Widget _buildSupportOption(String label, IconData icon, double screenWidth, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: themeProvider.accentColor,
              fontSize: screenWidth * 0.06, // Increased font size for better visibility
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(
          icon,
          color: Colors.black,
          size: screenWidth * 0.07, // Increased icon size for better visibility
        ),
      ],
    );
  }

  // Method to build the contact row at the bottom
  Widget _buildContactOption(String label, IconData icon, double screenWidth, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: themeProvider.accentColor,
              fontSize: screenWidth * 0.06, // Increased font size for better visibility
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(
          icon,
          color: Colors.black,
          size: screenWidth * 0.07, // Increased icon size for better visibility
        ),
      ],
    );
  }
}
