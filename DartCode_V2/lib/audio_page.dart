import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:http/http.dart' as http;
import 'theme_provider.dart'; // Import ThemeProvider
import 'notification_provider.dart';
import 'bottom_nav_bar.dart';

class AudioPage extends StatefulWidget {
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  // Variables to hold the state of the toggles and intensity buttons
  // bool notifications = false;
  bool haptic = true;
  double hapticIntensity = 25.0; // Use double for Haptic Intensity (initial value)
  bool buzzer = true;
  double buzzerIntensity = 75.0; // Use double for Buzzer Intensity (initial value)

  Timer? _timer;

  Future<void> fetchStatusData() async {
    final url = Uri.parse("http://192.168.4.1/get");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<String> values = response.body.split(" ");
        if (values.length >= 6) {
          setState(() {
            hapticIntensity = values[4] == '0' ? 0 : values[4] == '70' ? 25 : values[4] == '80' ? 50 : values[4] == '90' ? 75 : 100;
            haptic = hapticIntensity == 0 ? false : true; 
            buzzerIntensity = values[2] == '0' ? 0 : values[2] == '1' ? 25 : values[2] == '3' ? 50 : values[2] == '5' ? 75 : 100;
            buzzer = buzzerIntensity == 0 ? false : true; 
          });
        }
      } else {
        print("Failed to load data, status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStatusData();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) => fetchStatusData());
  }
  
  @override
  void dispose() {
    _timer?.cancel(); // Annuleer de timer bij het sluiten van de widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    // Get screen dimensions for dynamic scaling
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // Adjust padding and spacing dynamically based on screen size
    double horizontalPadding = screenWidth * 0.1; // 10% padding
    double buttonSpacing = screenHeight * 0.05; // Spacing between buttons

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.grey[800] // Dark background for dark theme
          : Colors.grey[300], // Light background for light theme
      body: SafeArea(
        child: Container(
          // // Apply a gray filter using a semi-transparent color overlay
          // decoration: BoxDecoration(
          //   color: Colors.grey[300], // Base color for the background
          //   backgroundBlendMode: BlendMode.overlay, // Blend mode for the gray filter
          // ),
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
                            'AUDIO',
                            style: TextStyle(
                              color: themeProvider.accentColor == Colors.white ? Colors.black : Colors.white, // adjusts the text color only if the accent color is white
                              fontSize: screenWidth * 0.08, // Dynamic font size based on screen width
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: buttonSpacing), // Space between header and rows

                    // Notifications Toggle
                    _buildSwitchRow('NOTIFICATIONS', notificationProvider.notifications, (value) {
                      setState(() {
                        notificationProvider.notifications = value;
                      });
                    }, maxWidth, screenWidth, themeProvider),
                    SizedBox(height: buttonSpacing), // Spacing between rows

                    // Haptic Toggle
                    _buildSwitchRow('HAPTIC', haptic, (value) {
                      setState(() {
                        haptic = value;
                        if (haptic) {
                          _sendIntensityData('Haptic', hapticIntensity == 25 ? 70 : hapticIntensity == 50 ? 80 : hapticIntensity == 75 ? 90 : 100);
                        } else {
                          _sendIntensityData('Haptic', 0.0);
                        }
                      });
                    }, maxWidth, screenWidth, themeProvider),
                    SizedBox(height: buttonSpacing), // Spacing between rows

                    // Haptic Intensity Button
                    _buildIntensityButtonRow('HAPTIC INTENSITY', hapticIntensity, () {
                      setState(() {
                        if (haptic) {
                          hapticIntensity = _cycleIntensity(hapticIntensity); // Ensure this is a double
                          _sendIntensityData('Haptic', hapticIntensity == 25 ? 70 : hapticIntensity == 50 ? 80 : hapticIntensity == 75 ? 90 : 100);
                        } else {
                          _sendIntensityData('Haptic', 0.0);
                        }
                      });
                    }, maxWidth, screenWidth, themeProvider),
                    SizedBox(height: buttonSpacing), // Spacing between rows

                    // Buzzer Toggle
                    _buildSwitchRow('BUZZER', buzzer, (value) {
                      setState(() {
                        buzzer = value;
                        if (buzzer) {
                          _sendIntensityData('Buzzer', buzzerIntensity == 25 ? 1 : buzzerIntensity == 50 ? 3 : buzzerIntensity == 75 ? 5 : 10);
                        } else {
                          _sendIntensityData('Buzzer', 0.0);
                        }
                      });
                    }, maxWidth, screenWidth, themeProvider),
                    SizedBox(height: buttonSpacing), // Spacing between rows

                    // Buzzer Intensity Button
                    _buildIntensityButtonRow('BUZZER INTENSITY', buzzerIntensity, () {
                      setState(() {
                        if (buzzer) {
                          buzzerIntensity = _cycleIntensity(buzzerIntensity); // Ensure this is a double
                          _sendIntensityData('Buzzer', buzzerIntensity == 25 ? 1 : buzzerIntensity == 50 ? 3 : buzzerIntensity == 75 ? 5 : 10);
                        } else {
                          _sendIntensityData('Buzzer', 0.0);
                        }
                      });
                    }, maxWidth, screenWidth, themeProvider),
                    SizedBox(height: buttonSpacing), // Larger space before the return button

                    Spacer(),

                    SizedBox(height: buttonSpacing),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentPage: "Audio"),
    );
  }

  // Method to send the haptic and buzzer intensity values to the server
  Future<void> _sendIntensityData(String type, double intensityValue) async {
    final url = Uri.parse("http://192.168.4.1/set");
    try {
      String dataString = "$type\$$intensityValue\$";

      final response = await http.post(url, body: {
        'data' : dataString,
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
              fontSize: screenWidth * 0.045, // Dynamic font size for labels
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

  // Method to build each row with a label and a button for intensity
  Widget _buildIntensityButtonRow(String label, double intensityValue, Function() onPressed, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Label part of the row
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: themeProvider.accentColor, // Use accent color for label
              fontSize: screenWidth * 0.045, // Dynamic font size for labels
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Button part of the row to display the current intensity and change it
        Container(
          width: maxWidth / 3, // Ensures each grey box has the same width
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: themeProvider.themeMode == ThemeMode.dark
                  ? Colors.grey[850]
                  : Colors.grey[400],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextButton(
              onPressed: onPressed, // Change the intensity when pressed
              child: Text(
                '${intensityValue.toInt()}%', // Display the current intensity as an integer
                style: TextStyle(
                  color: themeProvider.accentColor, // Use accent color for intensity value
                  fontSize: screenWidth * 0.045, // Dynamic font size for intensity values
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
