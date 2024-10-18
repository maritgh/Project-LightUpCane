import 'package:flutter/material.dart';
import 'custom_button.dart'; // Import the CustomButton used in the rest of the app

class AudioPage extends StatefulWidget {
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  // Variables to hold the state of the toggles and intensity buttons
  bool notifications = false;
  bool haptic = true;
  double hapticIntensity = 25.0; // Use double for Haptic Intensity (initial value)
  bool buzzer = true;
  double buzzerIntensity = 75.0; // Use double for Buzzer Intensity (initial value)

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
                  // Audio Title
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
                          'AUDIO',
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

                  // Notifications Toggle
                  _buildSwitchRow('NOTIFICATIONS', notifications, (value) {
                    setState(() {
                      notifications = value;
                    });
                  }, maxWidth, screenWidth),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Haptic Toggle
                  _buildSwitchRow('HAPTIC', haptic, (value) {
                    setState(() {
                      haptic = value;
                    });
                  }, maxWidth, screenWidth),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Haptic Intensity Button
                  _buildIntensityButtonRow('HAPTIC INTENSITY', hapticIntensity, () {
                    setState(() {
                      hapticIntensity = _cycleIntensity(hapticIntensity); // Ensure this is a double
                    });
                  }, maxWidth, screenWidth),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Buzzer Toggle
                  _buildSwitchRow('BUZZER', buzzer, (value) {
                    setState(() {
                      buzzer = value;
                    });
                  }, maxWidth, screenWidth),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Buzzer Intensity Button
                  _buildIntensityButtonRow('BUZZER INTENSITY', buzzerIntensity, () {
                    setState(() {
                      buzzerIntensity = _cycleIntensity(buzzerIntensity); // Ensure this is a double
                    });
                  }, maxWidth, screenWidth),
                  SizedBox(height: buttonSpacing), // Larger space before the return button

                  Spacer(),

                  // Return Button
                  CustomButton(
                    label: 'RETURN',
                    onPressed: () {
                      Navigator.pop(context); // Navigate back when Return is pressed
                    },
                    screenWidth: screenWidth, // Pass screen dimensions for dynamic sizing
                    screenHeight: screenHeight,
                  ),
                  SizedBox(height: buttonSpacing),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Method to build each row with a label and a switch
  Widget _buildSwitchRow(String label, bool switchValue, Function(bool) onChanged, double maxWidth, double screenWidth) {
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
        // Switch part of the row
        Container(
          width: maxWidth / 3, // Ensures each grey box has the same width
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // decoration: BoxDecoration(
          //   color: Colors.grey[400],
          //   borderRadius: BorderRadius.circular(5),
          // ),
          child: Center(
            child: Switch(
              value: switchValue,
              onChanged: onChanged,
              activeColor: Colors.purple, // Color for the active switch
            ),
          ),
        ),
      ],
    );
  }

  // Method to build each row with a label and a button for intensity
  Widget _buildIntensityButtonRow(String label, double intensityValue, Function() onPressed, double maxWidth, double screenWidth) {
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
        // Button part of the row to display the current intensity and change it
        Container(
          width: maxWidth / 3, // Ensures each grey box has the same width
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextButton(
              onPressed: onPressed, // Change the intensity when pressed
              child: Text(
                '${intensityValue.toInt()}%', // Display the current intensity as an integer
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: screenWidth * 0.05, // Dynamic font size for intensity values
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Function to cycle through the intensity values (25.0, 50.0, 75.0, 100.0)
  double _cycleIntensity(double currentValue) {
    // Ensure all values are within the range and wrap around the values
    switch (currentValue) {
      case 25.0:
        return 50.0;
      case 50.0:
        return 75.0;
      case 75.0:
        return 100.0;
      case 100.0:
        return 25.0;
      default:
        return 25.0;
    }
  }
}
