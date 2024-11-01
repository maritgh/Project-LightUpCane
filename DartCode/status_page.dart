import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'custom_button.dart'; // Import the CustomButton used in the rest of the app
import 'theme_provider.dart'; // Import your ThemeProvider

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  // Variables to hold the status information
  String battery = '90%';
  bool isLightOn = true; // ON/OFF
  String lightIntensity = 'LOW';
  bool notifications = false; // ON/OFF
  String hapticIntensity = '25%';
  String buzzerIntensity = '75%';

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
                  // Status Title
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
                          'STATUS',
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

                  // Battery
                  _buildStatusRow('BATTERY', battery, maxWidth, screenWidth, themeProvider),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Light with Toggle Switch
                  _buildLightToggleRow('LIGHT', isLightOn, maxWidth, screenWidth, themeProvider),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Notifications with Toggle Switch
                  _buildNotificationsToggleRow('NOTIFICATIONS', notifications, maxWidth, screenWidth, themeProvider),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Light Intensity with Clickable Block
                  _buildLightIntensityRow('LIGHT INTENSITY', lightIntensity, maxWidth, screenWidth, themeProvider),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Haptic Intensity
                  _buildStatusRow('HAPTIC INTENSITY', hapticIntensity, maxWidth, screenWidth, themeProvider),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Buzzer Intensity
                  _buildStatusRow('BUZZER INTENSITY', buzzerIntensity, maxWidth, screenWidth, themeProvider),
                  SizedBox(height: buttonSpacing), // Larger space before the return button

                  // Return Button
                  CustomButton(
                    label: 'RETURN',
                    onPressed: () {
                      Navigator.pop(context); // Navigate back when Return is pressed
                    },
                    screenWidth: screenWidth, // Pass screen dimensions for dynamic sizing
                    screenHeight: screenHeight,
                    color: themeProvider.accentColor, // Use accent color from ThemeProvider
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Method to build each status row
  Widget _buildStatusRow(String label, String value, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label part of the row
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: themeProvider.accentColor, // Use accent color for labels
              fontSize: screenWidth * 0.05, // Dynamic font size for labels
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Value part of the row
        Container(
          width: maxWidth / 3, // Ensures each grey box has the same width
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: themeProvider.accentColor, // Use accent color for values
                fontSize: screenWidth * 0.05, // Dynamic font size for values
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Light toggle row
  Widget _buildLightToggleRow(String label, bool value, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label part of the row
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: themeProvider.accentColor, // Use accent color for labels
              fontSize: screenWidth * 0.05, // Dynamic font size for labels
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Switch for light toggle
        Container(
          width: maxWidth / 3, // Ensures each grey box has the same width
          child: Switch(
            value: value,
            onChanged: (bool newValue) {
              setState(() {
                isLightOn = newValue; // Toggle the light status
              });
            },
            activeColor: themeProvider.accentColor, // Use accent color for active switch
            inactiveThumbColor: Colors.grey, // Color for inactive thumb
          ),
        ),
      ],
    );
  }

  // Notifications toggle row
  Widget _buildNotificationsToggleRow(String label, bool value, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label part of the row
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: themeProvider.accentColor, // Use accent color for labels
              fontSize: screenWidth * 0.05, // Dynamic font size for labels
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Switch for notifications toggle
        Container(
          width: maxWidth / 3, // Ensures each grey box has the same width
          child: Switch(
            value: value,
            onChanged: (bool newValue) {
              setState(() {
                notifications = newValue; // Toggle the notifications status
              });
            },
            activeColor: themeProvider.accentColor, // Use accent color for active switch
            inactiveThumbColor: Colors.grey, // Color for inactive thumb
          ),
        ),
      ],
    );
  }

  // Light intensity row with GestureDetector
  Widget _buildLightIntensityRow(String label, String value, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    List<String> intensities = ['LOW', 'MID', 'HIGH']; // Define possible intensity levels

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label part of the row
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: themeProvider.accentColor, // Use accent color for labels
              fontSize: screenWidth * 0.05, // Dynamic font size for labels
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            setState(() {
              // Current index of the intensity level
              int currentIndex = intensities.indexOf(value);

              // Next intensity level
              lightIntensity = intensities[(currentIndex + 1) % intensities.length];
            });
          },
          child: Container(
            width: maxWidth / 3, // Ensures each grey box has the same width
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                value, // Display current light intensity
                style: TextStyle(
                  color: themeProvider.accentColor, // Use accent color for values
                  fontSize: screenWidth * 0.05, // Dynamic font size for values
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
