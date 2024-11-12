import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'theme_provider.dart'; // Import ThemeProvider
import 'bottom_nav_bar.dart';

class LightPage extends StatefulWidget {
  @override
  _LightPageState createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {
  // Variables to hold the state of the toggles and intensity buttons
  bool light = false;
  String lightIntensity = 'LOW';

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
              double maxWidth = constraints.maxWidth - 40; // Ensure padding from edges

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Audio Title
                  Center(
                    child: Container(
                      width: screenWidth * 0.8,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                      decoration: BoxDecoration(
                        color: themeProvider.accentColor, // Use accent color from ThemeProvider
                        borderRadius: BorderRadius.circular(20), // Rounded corners for the status header
                      ),
                      child: Center(
                        child: Text(
                          'LIGHT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.08, // Dynamic font size based on screen width
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: buttonSpacing), // Space between header and rows

                  // Light Toggle
                  _buildSwitchRow('NOTIFICATIONS', light, (value) {
                    setState(() {
                      light = value;
                    });
                  }, maxWidth, screenWidth, themeProvider),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Light Intensity Toggle
                  _buildLightIntensityRow('LIGHT INTENSITY', lightIntensity, maxWidth, screenWidth, themeProvider),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  Spacer(),

                  SizedBox(height: buttonSpacing),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentPage: "Light"),
    );
  }

  // Method to build each row with a label and a switch
  Widget _buildSwitchRow(String label, bool switchValue, Function(bool) onChanged, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label part of the row
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: themeProvider.accentColor, // Use accent color for label
              fontSize: screenWidth * 0.05, // Dynamic font size for labels
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Switch part of the row
        Container(
          width: maxWidth / 3, // Ensures each grey box has the same width
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Center(
            child: Switch(
              value: switchValue,
              onChanged: onChanged,
              activeColor: themeProvider.accentColor, // Color for the active switch
            ),
          ),
        ),
      ],
    );
  }

  // Updated Light Intensity row with cycling button
  Widget _buildLightIntensityRow(String label, String value, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    List<String> intensities = ['LOW', 'MID', 'HIGH'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: themeProvider.accentColor,
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              int currentIndex = intensities.indexOf(value);
              lightIntensity = intensities[(currentIndex + 1) % intensities.length];
            });
          },
          child: Container(
            width: maxWidth / 3,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  color: themeProvider.accentColor,
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
