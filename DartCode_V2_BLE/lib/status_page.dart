import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'generated/l10n.dart';
import 'theme_provider.dart';
import 'notification_provider.dart';
import 'support_page.dart';
import 'bottom_nav_bar.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {

  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? setCharacteristic;
  BluetoothCharacteristic? getCharacteristic;

  final String serviceUuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String setCharacteristicUuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  final String getCharacteristicUuid = "6d140001-bcb0-4c43-a293-b21a53dbf9f5";
  // Variables to hold the status information
  String battery = '';
  String light = '';
  String lightIntensity = '';
  String notifications = '';
  String hapticIntensity = '';
  String buzzerIntensity = '';
  String buzzerFrequency = '';

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
      setState(() {
       battery = "${values[0]}%";
            light = values[5] == "1" ? S.of(context).on : S.of(context).off;
            lightIntensity = values[1] == "30" ? S.of(context).low : values[1] == "60" ? S.of(context).medium : S.of(context).high;
            hapticIntensity = "${values[4] == '0' ? 0 : values[4] == '70' ? 25 : values[4] == '80' ? 50 : values[4] == '90' ? 75 : 100}%";
            buzzerIntensity = "${values[2] == '0' ? 0 : values[2] == '1' ? 25 : values[2] == '3' ? 50 : values[2] == '5' ? 75 : 100}%";
            buzzerFrequency = "${values[3]}%";
        // errorMessage = ''; // Clear any previous error message
      });
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
    //_timer?.cancel(); // Annuleer de timer bij het sluiten van de widget
    super.dispose();
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
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    notifications = notificationProvider.notifications == true ? S.of(context).on : S.of(context).off;

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.grey[800]
          : Colors.grey[300],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Center(
                child: Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                  decoration: BoxDecoration(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.grey[850]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      S.of(context).status,
                      style: TextStyle(
                        color: themeProvider.accentColor, // Use accent color from ThemeProvider
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double maxWidth = constraints.maxWidth - 40;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDisplayRow(S.of(context).battery, battery, maxWidth, screenWidth, themeProvider),
                        _buildDisplayRow(S.of(context).light, light, maxWidth, screenWidth, themeProvider),
                        _buildDisplayRow(S.of(context).notifications, notifications, maxWidth, screenWidth, themeProvider),
                        _buildDisplayRow(S.of(context).light_intensity, lightIntensity, maxWidth, screenWidth, themeProvider),
                        _buildDisplayRow(S.of(context).haptic_intensity, hapticIntensity, maxWidth, screenWidth, themeProvider),
                        _buildDisplayRow(S.of(context).buzzer_intensity, buzzerIntensity, maxWidth, screenWidth, themeProvider),
                      ],
                    );
                  },
                ),
              ),
            ),

            // Help Icon in the center under buzzer intensity, with controlled size
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.help_outline,
                  color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                  size: screenWidth * 0.1,
                  semanticLabel: S.of(context).support,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SupportPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentPage: "Status"),
    );
  }

  Widget _buildDisplayRow(String label, String value, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return Semantics(
      label: "$label: $value", // Combine label and value for TalkBack to read as one.
      excludeSemantics: true, // Prevent child widgets from being read separately.
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
    );
  }
}
