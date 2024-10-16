import 'package:flutter/material.dart';
import 'custom_button.dart'; // Import the CustomButton used in the rest of the app

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  // Variables to hold the status information
  String battery = '90%';
  String light = 'ON';
  String lightIntensity = 'LOW';
  String notifications = 'OFF';
  String hapticIntensity = '25%';
  String buzzerIntensity = '100%';

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for dynamic scaling
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // Adjust padding and spacing dynamically based on screen size
    double horizontalPadding = screenWidth * 0.1; // 10% padding
    double buttonSpacing = screenHeight * 0.05; // Spacing between buttons

    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                        color: Colors.black,
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
                  _buildStatusRow('BATTERY', battery, maxWidth, screenWidth),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Light
                  _buildStatusRow('LIGHT', light, maxWidth, screenWidth),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Light Intensity
                  _buildStatusRow('LIGHT INTENSITY', lightIntensity, maxWidth, screenWidth),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Notifications
                  _buildStatusRow('NOTIFICATIONS', notifications, maxWidth, screenWidth),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Haptic Intensity
                  _buildStatusRow('HAPTIC INTENSITY', hapticIntensity, maxWidth, screenWidth),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Buzzer Intensity
                  _buildStatusRow('BUZZER INTENSITY', buzzerIntensity, maxWidth, screenWidth),
                  SizedBox(height: buttonSpacing), // Larger space before the return button

                  // Return Button
                  CustomButton(
                    label: 'RETURN',
                    onPressed: () {
                      Navigator.pop(context); // Navigate back when Return is pressed
                    },
                    screenWidth: screenWidth, // Pass screen dimensions for dynamic sizing
                    screenHeight: screenHeight,
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
  Widget _buildStatusRow(String label, String value, double maxWidth, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label part of the row
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.purple,
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
                color: Colors.purple,
                fontSize: screenWidth * 0.05, // Dynamic font size for values
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
