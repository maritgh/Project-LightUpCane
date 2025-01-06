import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'custom_button.dart';
import 'theme_page.dart';
import 'connection_page.dart';
import 'theme_provider.dart';
import 'bottom_nav_bar.dart'; // Import your BottomNavBar
 
class SettingsAppPage extends StatefulWidget {
  const SettingsAppPage({Key? key}) : super(key: key);
 
  @override
  _SettingsAppPageState createState() => _SettingsAppPageState();
}
 
class _SettingsAppPageState extends State<SettingsAppPage> {
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
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.grey[850]
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(
                            20), // Rounded corners for the header
                      ),
                      child: Center(
                        child: Text(
                          'SETTINGS APP',
                          style: TextStyle(
                            color: themeProvider
                                .accentColor, // Use accent color from ThemeProvider
                            fontSize: screenWidth *
                                0.08, // Dynamic font size based on screen width
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          buttonSpacing * 3), // Space between title and buttons
 
                  // Theme Button
                  CustomButton(
                    label: 'THEME',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ThemePage()),
                      );
                    },
                    screenWidth:
                        screenWidth, // Pass screen dimensions for dynamic sizing
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
                        MaterialPageRoute(
                            builder: (context) => const ConnectionPage()),
                      );
                    },
                    screenWidth:
                        screenWidth, // Pass screen dimensions for dynamic sizing
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
                    //  ScaffoldMessenger.of(context).showSnackBar(
                    //    const SnackBar(content: Text('Finding your cane...')),
                      );
                    },
                    child: Container(
                      height: screenHeight *
                          0.25, // Adjust size based on screen height
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dynamicColor,
                      ),
                      child: Center(
                        child: Text(
                          'FIND MY CANE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeProvider
                                .accentColor, // Use accent color from ThemeProvider
                            fontSize: screenWidth *
                                0.05, // Dynamic font size based on screen width
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(), // Push content up to make space for bottom navigation bar
 
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
 
  // Method to send the haptic and buzzer intensity values to the server
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
