import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../generated/l10n.dart';
import 'theme_provider.dart'; // Import ThemeProvider
import 'notification_provider.dart';
import 'bottom_nav_bar.dart';
import 'package:flutter/semantics.dart';

class AudioPage extends StatefulWidget {
  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  // Variables to hold the state of the toggles and intensity buttons
  // bool notifications = false;
  // bool haptic = true;
  // double hapticIntensity = 25.0; // Use double for Haptic Intensity (initial value)
  // bool buzzer = true;
  // double buzzerIntensity = 75.0; // Use double for Buzzer Intensity (initial value)

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
                } else if (characteristic.uuid.toString() ==
                    getCharacteristicUuid) {
                  getCharacteristic = characteristic;
                  await getCharacteristic!.setNotifyValue(true);
                  getCharacteristic!.value.listen((value) {
                    // Ontvang gegevens van het apparaat
                    String data = String.fromCharCodes(value);
                    _handleReceivedData(data);
                  });
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

  void _handleReceivedData(String data) {
    List<String> values = data.split(" ");
    if (values.length >= 6) {
       final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
          notificationProvider.setHapticIntensity(values[4] == '0' ? 0 : values[4] == '70' ? 25 : values[4] == '80' ? 50 : values[4] == '90' ? 75 : 100);  
          notificationProvider.setHaptic(notificationProvider.hapticIntensity > 0);
          notificationProvider.setBuzzerIntensity(values[2] == '0' ? 0 : values[2] == '1' ? 25 : values[2] == '3' ? 50 : values[2] == '5' ? 75 : 100);
  	      notificationProvider.setBuzzer(notificationProvider.buzzerIntensity > 0);
    }
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
  void initState() {
    super.initState();
    connectToDevice();
  }

  @override
  void dispose() {
    _disconnectFromDevice();
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
                double maxWidth =
                    constraints.maxWidth - 40; // Ensure padding from edges

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Audio Title
                    Center(
                      child: Container(
                        width: screenWidth * 0.8,
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.005),
                        decoration: BoxDecoration(
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.grey[850]
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(
                              20), // Rounded corners for the status header
                        ),
                        child: Center(
                          child: Text(
                           S.of(context).audio_settings,
                            style: TextStyle(
                              color: themeProvider
                                  .accentColor, // Use accent color from ThemeProvider
                              fontSize: screenWidth *
                                  0.070, // Dynamic font size based on screen width
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: buttonSpacing), // Space between header and rows

                    // Notifications Toggle
                    _buildSwitchRow(S.of(context).notifications,
                        notificationProvider.notifications, (value) {
                      setState(() {
                        notificationProvider.setNotifications(value);
                       
                      });
                    }, maxWidth, screenWidth, themeProvider),
                    SizedBox(height: buttonSpacing), // Spacing between rows

                    // Haptic Toggle
                    _buildSwitchRow(
                        S.of(context).haptic, notificationProvider.haptic,
                        (value) {
                      setState(() {
                        notificationProvider.setHaptic(value);
                        if (notificationProvider.haptic) {
                          _sendIntensityData(
                              'Haptic',
                              notificationProvider.hapticIntensity == 25
                                  ? 70
                                  : notificationProvider.hapticIntensity == 50
                                      ? 80
                                      : notificationProvider.hapticIntensity ==
                                              75
                                          ? 90
                                          : 100);
                        } else {
                          _sendIntensityData('Haptic', 0.0);
                        }
                      });
                    }, maxWidth, screenWidth, themeProvider),
                    SizedBox(height: buttonSpacing), // Spacing between rows

                    // Haptic Intensity Button
                    _buildIntensityButtonRow(S.of(context).haptic_intensity,
                        notificationProvider.hapticIntensity, () {
                      setState(() {
                        final newHapticIntensity = _cycleIntensity(
                            notificationProvider.hapticIntensity);
                        notificationProvider
                            .setHapticIntensity(newHapticIntensity);
                        if (notificationProvider.haptic) {
                          _sendIntensityData(
                              'Haptic',
                              newHapticIntensity == 25
                                  ? 70
                                  : newHapticIntensity == 50
                                      ? 80
                                      : newHapticIntensity == 75
                                          ? 90
                                          : 100);
                        } else {
                          _sendIntensityData('Haptic', 0.0);
                        }
                      });
                    }, maxWidth, screenWidth, themeProvider),
                    SizedBox(height: buttonSpacing), // Spacing between rows

                    // Buzzer Toggle
                    _buildSwitchRow(
                        S.of(context).buzzer, notificationProvider.buzzer,
                        (value) {
                      setState(() {
                        notificationProvider.setBuzzer(value);
                        if (notificationProvider.buzzer) {
                          _sendIntensityData(
                              'Buzzer',
                              notificationProvider.buzzerIntensity == 25
                                  ? 1
                                  : notificationProvider.buzzerIntensity == 50
                                      ? 3
                                      : notificationProvider.buzzerIntensity ==
                                              75
                                          ? 5
                                          : 10);
                        } else {
                          _sendIntensityData('Buzzer', 0.0);
                        }
                      });
                    }, maxWidth, screenWidth, themeProvider),
                    SizedBox(height: buttonSpacing), // Spacing between rows

                    // Buzzer Intensity Button
                    _buildIntensityButtonRow(S.of(context).buzzer_intensity,
                        notificationProvider.buzzerIntensity, () {
                      setState(() {
                        final newBuzzerIntensity = _cycleIntensity(
                            notificationProvider.buzzerIntensity);
                        notificationProvider
                            .setBuzzerIntensity(newBuzzerIntensity);
                        if (notificationProvider.buzzer) {
                          _sendIntensityData(
                              'Buzzer',
                              newBuzzerIntensity == 25
                                  ? 1
                                  : newBuzzerIntensity == 50
                                      ? 3
                                      : newBuzzerIntensity == 75
                                          ? 5
                                          : 10);
                        } else {
                          _sendIntensityData('Buzzer', 0.0);
                        }
                      });
                    }, maxWidth, screenWidth, themeProvider),
                    SizedBox(
                        height:
                            buttonSpacing), // Larger space before the return button

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

  // Method to build each row with a label and a switch
  Widget _buildSwitchRow(
      String label,
      bool switchValue,
      Function(bool) onChanged,
      double maxWidth,
      double screenWidth,
      ThemeProvider themeProvider) {
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
              activeColor:
                  themeProvider.accentColor, // Color for the active switch
            ),
          ),
        ),
      ],
    );
  }

  // Method to build each row with a label and a button for intensity
  Widget _buildIntensityButtonRow(
      String label,
      double intensityValue,
      Function() onPressed,
      double maxWidth,
      double screenWidth,
      ThemeProvider themeProvider) {
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
                  color: themeProvider
                      .accentColor, // Use accent color for intensity value
                  fontSize: screenWidth *
                      0.045, // Dynamic font size for intensity values
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
