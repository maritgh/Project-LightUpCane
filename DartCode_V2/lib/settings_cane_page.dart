import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'custom_button.dart';
import 'audio_page.dart';
import 'light_page.dart';
import 'theme_provider.dart';
import 'bottom_nav_bar.dart'; // Import your BottomNavBar

class SettingsCanePage extends StatefulWidget {
  const SettingsCanePage({Key? key}) : super(key: key);

  @override
  _SettingsCanePageState createState() => _SettingsCanePageState();
}

class _SettingsCanePageState extends State<SettingsCanePage> {
  
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

    // Define the dynamic color based on the theme, required for AUDIO and LIGHT to adjust theme
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
                  // Settings Cane Title
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
                          'SETTINGS CANE',
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
                    color: dynamicColor, // Use accent color from ThemeProvider
                  ),
                  SizedBox(height: buttonSpacing), // Spacing between buttons

                  // Light Button
                  CustomButton(
                    label: 'LIGHT',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LightPage()),
                      );
                    },
                    screenWidth: screenWidth, // Pass screen dimensions for dynamic sizing
                    screenHeight: screenHeight,
                    color: dynamicColor, // Use accent color from ThemeProvider
                  ),
                  SizedBox(height: buttonSpacing), // Spacing between buttons

                  // Find My Cane Button
                  GestureDetector(
                    onTap: () {
                      _sendIntensityData('Find', 0);
                      // Add your "Find My Cane" action here
                      print('Find My Cane button pressed');
                      // ScaffoldMessenger.of(context).showSnackBar(
                      // const SnackBar(content: Text('Finding your cane...')),
                      // );
                    },
                    child: Container(
                      height: screenHeight * 0.25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dynamicColor,
                      ),
                      child: Center(
                        child: Text(
                          'Find My Cane',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeProvider.accentColor,
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Spacer(), // Push content up to make space for bottom navigation bar

                  SizedBox(height: buttonSpacing),
                ],
              );
            },
          ),
        ),
      ),
      // Add the BottomNavBar with the currentPage set to "SettingsCane"
      bottomNavigationBar: BottomNavBar(currentPage: "SettingsCane"),
    );
  }

  Future<void> _sendIntensityData(String type, double intensityValue) async {
    final url = Uri.parse("http://192.168.4.1/set");
    try {
      String dataString = "$type\$$intensityValue\$";
 
      final response = await http.post(url, body: {
        'data': dataString,
      });
      if (response.statusCode == 200) {
        print("Data send succesfully");
      } else {
        print("Failed to send data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending data: $e");
    }
  }
}
