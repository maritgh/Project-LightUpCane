import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'custom_button.dart'; // Import the CustomButton used in the rest of the app
import 'theme_provider.dart'; // Import ThemeProvider

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  bool isBluetoothOn = false; //Track Bluetooth status
  String pairedDevices = 'Paired devices';
  String cane1 = 'Cane 1';
  String cane2 = 'Cane 2';
  String connected = 'Connected';

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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: buttonSpacing), // Top spacing

                  // Connection Header
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
                          'CONNECTION',
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

                  // Bluetooth Status Toggle Button
                  _buildBluetoothToggleButton(maxWidth, screenWidth, themeProvider),
                  SizedBox(height: buttonSpacing), // Spacing between rows

                  // Display message when Bluetooth is off
                  if (!isBluetoothOn)
                    Center(
                      child: Text(
                        'Please turn on Bluetooth to connect your device to the LightUp Cane',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeProvider.accentColor, // Use accent color from ThemeProvider
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else ...[
                    // Only show these widgets when Bluetooth is on
                    SizedBox(height: buttonSpacing), // Space between rows

                    // Paired Devices Label
                    Text(
                      pairedDevices,
                      style: TextStyle(
                        color: themeProvider.accentColor, // Use accent color from ThemeProvider
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02), // Spacing below paired devices label

                    // Cane 1 - Connected
                    _buildDeviceRow(cane1, connected, maxWidth, screenWidth, themeProvider),
                    SizedBox(height: screenHeight * 0.02), // Spacing between rows

                    // Cane 2 - Not Connected
                    _buildDeviceRow(cane2, '', maxWidth, screenWidth, themeProvider),
                    SizedBox(height: buttonSpacing), // Spacing between rows

                    // Connect to Cane Button
                    Center(
                      child: CustomButton(
                        label: 'Connect to Cane',
                        onPressed: () {
                          // Add connection functionality here
                        },
                        screenWidth: screenWidth, // Pass screen dimensions for dynamic sizing
                        screenHeight: screenHeight,
                        color: themeProvider.accentColor, // Use accent color from ThemeProvider
                      ),
                    ),
                  ],

                  Spacer(), // Pushes RETURN button to the bottom

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
                  SizedBox(height: buttonSpacing), // Bottom padding
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Method to build the Bluetooth toggle button
  Widget _buildBluetoothToggleButton(double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isBluetoothOn = !isBluetoothOn; // Toggle Bluetooth status
        });
      },
      child: Container(
        width: maxWidth,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bluetooth, color: themeProvider.accentColor),
            SizedBox(width: 10),
            Text(
              isBluetoothOn ? 'Bluetooth on' : 'Bluetooth off',
              style: TextStyle(
                color: themeProvider.accentColor,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build each device row
  Widget _buildDeviceRow(String deviceName, String connectionStatus, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            deviceName,
            style: TextStyle(
              color: themeProvider.accentColor, // Use accent color from ThemeProvider
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            connectionStatus,
            style: TextStyle(
              color: connectionStatus.isNotEmpty ? themeProvider.accentColor : Colors.transparent,
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
