import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'generated/l10n.dart';
import 'theme_provider.dart';
import 'notification_provider.dart';
import 'bottom_nav_bar.dart';

class LightPage extends StatefulWidget {
  @override
  _LightPageState createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {
  Timer? _timer;

  Future<void> fetchStatusData() async {
    final url = Uri.parse("http://192.168.4.1/get");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<String> values = response.body.split(" ");
        if (values.length >= 6) {
          final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
          notificationProvider.setLightIntensity(values[1] == '30' ? '30' : values[1] == '60' ? '60' : '100');
          notificationProvider.setLight(values[5] == '0' ? false : true);
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
    _timer?.cancel();
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth - 40; // Ensure padding from edges

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Light Title
                  Center(
                    child: Container(
                      width: screenWidth * 0.8,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.grey[850]
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(20), // Rounded corners for the status header
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).light_settings,
                          style: TextStyle(
                            color: themeProvider.accentColor, // Use accent color from ThemeProvider
                            fontSize: screenWidth * 0.08, // Dynamic font size based on screen width
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: buttonSpacing), // Space between header and rows

                  // Light Toggle
                  _buildSwitchRow(S.of(context).light, notificationProvider.light, (value) {
                    setState(() {
                      notificationProvider.setLight(value);
                      _sendIntensityData('LightSwitch', notificationProvider.light ? 1 : 0);
                      _sendIntensityData('Light', notificationProvider.lightIntensity == '30' ? 30 : notificationProvider.lightIntensity == '60' ? 60 : 100);
                    });
                  }, maxWidth, screenWidth, themeProvider),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Light Intensity Toggle
                  _buildLightIntensityRow(S.of(context).light_intensity, notificationProvider.lightIntensity, maxWidth, screenWidth, themeProvider, notificationProvider),
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
    String switchText = switchValue ? S.of(context).on : S.of(context).off;
    return Semantics(
      label: "$label: $switchText",
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () {
          bool newValue = !switchValue;
          onChanged(newValue);

          SemanticsService.announce("$label: ${newValue ? S.of(context).on : S.of(context).off}", TextDirection.ltr);
        },  
        child: Row(
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
        ),
      ),
    );    
  }

  // Updated Light Intensity row with cycling button
  Widget _buildLightIntensityRow(String label, String value, double maxWidth, double screenWidth, ThemeProvider themeProvider, NotificationProvider notificationProvider) {
    List<String> intensities = [S.of(context).low, S.of(context).medium, S.of(context).high];
    value = value == '30' ? S.of(context).low : value == '60' ? S.of(context).medium : S.of(context).high;

    return Semantics(
      label: "$label: $value",
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () {
          setState(() {
            int currentIndex = intensities.indexOf(value);
            final newLightIntensity = intensities[(currentIndex + 1) % intensities.length];
            notificationProvider.setLightIntensity(newLightIntensity == S.of(context).low ? '30' : newLightIntensity == S.of(context).medium ? '60' : '100');
            _sendIntensityData('Light', newLightIntensity == S.of(context).low ? 30 : newLightIntensity == S.of(context).medium ? 60 : 100);

            // Announce the new intensity using SemanticsService
            SemanticsService.announce("$label: $newLightIntensity", TextDirection.ltr);
          });
        },
        child: Row(
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
            Container(
              width: maxWidth / 3,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.grey[850]
                    : Colors.grey[400],
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
          ],
        ),
      ),
    );  
  }
}
