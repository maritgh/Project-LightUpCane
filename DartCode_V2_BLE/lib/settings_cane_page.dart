import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../generated/l10n.dart';
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
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? setCharacteristic;
  BluetoothCharacteristic? getCharacteristic;

  final String serviceUuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String setCharacteristicUuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  final String getCharacteristicUuid = "6d140001-bcb0-4c43-a293-b21a53dbf9f5";

  Future<void> connectToDevice() async {
    try {
      List<BluetoothDevice> devices = FlutterBluePlus.connectedDevices;
      for (BluetoothDevice device in devices) {
        if (device.name == 'light_up_cane') {
          connectedDevice = device;
          // Services en characteristics ontdekken
          List<BluetoothService> services =
              await connectedDevice!.discoverServices();
          for (BluetoothService service in services) {
            if (service.uuid.toString() == serviceUuid) {
              for (BluetoothCharacteristic characteristic
                  in service.characteristics) {
                if (characteristic.uuid.toString() == setCharacteristicUuid) {
                  setCharacteristic = characteristic;
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error connecting to device: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    connectToDevice();
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) => fetchStatusData());
  }

  void _disconnectFromDevice() {
    if (connectedDevice != null) {
      try {
        connectedDevice!.disconnect();
      } catch (e) {
        print("Error disconnecting device: $e");
      }
    }
  }

  @override
  void dispose() {
    _disconnectFromDevice();
    //   _timer?.cancel(); // Annuleer de timer bij het sluiten van de widget
    super.dispose();
  }

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
                          S.of(context).settings_cane,
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

                  // Audio Button
                  CustomButton(
                    label: S.of(context).audio,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AudioPage()),
                      );
                    },
                    screenWidth:
                        screenWidth, // Pass screen dimensions for dynamic sizing
                    screenHeight: screenHeight,
                    color: dynamicColor, // Use accent color from ThemeProvider
                  ),
                  SizedBox(height: buttonSpacing), // Spacing between buttons

                  // Light Button
                  CustomButton(
                    label: S.of(context).light,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LightPage()),
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
                          S.of(context).find_my_cane,
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
    try {
      if (setCharacteristic != null) {
        // Gebruik BLE om gegevens te verzenden
        String dataString = "$type $intensityValue";
        await setCharacteristic!
            .write(dataString.codeUnits, withoutResponse: false);
      }
    } catch (e) {
      print("Error sending data: $e");
    }
  }
}
