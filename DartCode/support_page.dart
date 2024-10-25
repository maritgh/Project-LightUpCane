import 'package:flutter/material.dart';
import 'custom_button.dart'; 

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for dynamic scaling
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // Adjust padding and spacing dynamically based on screen size
    double horizontalPadding = screenWidth * 0.1; // 10% padding
    double buttonSpacing = screenHeight * 0.07; // Increased spacing between buttons

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth - 40; // Ensure padding from edges

              return Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center the layout vertically
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Support Title
                  Center(
                    child: Container(
                      width: screenWidth * 0.8,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02), // Padding for title
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20), // Rounded corners for the title header
                      ),
                      child: Center(
                        child: Text(
                          'SUPPORT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.08, // Dynamic font size based on screen width
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: buttonSpacing), // Space between header and buttons

                  // Support Options (APP, PRESETS, SETTINGS, STATUS)
                  _buildSupportOption('APP', Icons.volume_up, screenWidth),
                  SizedBox(height: buttonSpacing), // Space between buttons
                  _buildSupportOption('PRESETS', Icons.volume_up, screenWidth),
                  SizedBox(height: buttonSpacing), // Space between buttons
                  _buildSupportOption('SETTINGS', Icons.volume_up, screenWidth),
                  SizedBox(height: buttonSpacing), // Space between buttons
                  _buildSupportOption('STATUS', Icons.volume_up, screenWidth),
                  SizedBox(height: buttonSpacing), // Space between buttons

                  // Contact Option at the bottom
                  _buildContactOption('CONTACT', Icons.phone, screenWidth),
                  SizedBox(height: buttonSpacing), // Spacing before the return button

                  // Return Button (copied from StatusPage)
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

  // Method to build each support option row (App, Presets, etc.)
  Widget _buildSupportOption(String label, IconData icon, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.purple,
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
  Widget _buildContactOption(String label, IconData icon, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.purple,
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
