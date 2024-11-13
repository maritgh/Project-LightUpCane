import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'custom_button.dart';
import 'theme_provider.dart';
import 'bottom_nav_bar.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  bool isBluetoothOn = false;
  String pairedDevices = 'Paired devices';
  String cane1 = 'Cane 1';
  String cane2 = 'Cane 2';
  String connected = 'Connected';
  late StreamSubscription<BluetoothAdapterState> bluetoothSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize Bluetooth state check if the platform is Android or iOS
    if (Platform.isAndroid || Platform.isIOS) {
      checkBluetoothSupport();
    }
  }

  @override
  void dispose() {
    bluetoothSubscription.cancel();
    super.dispose();
  }

  Future<void> checkBluetoothSupport() async {
    bool supported = await FlutterBluePlus.isSupported;
    if (!supported) {
      setState(() {
        isBluetoothOn = false;
      });
      print("Bluetooth not supported by this device");
      return;
    }
    handleBluetoothState();
  }

  void handleBluetoothState() {
    // Listen to Bluetooth adapter state changes
    bluetoothSubscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      setState(() {
        isBluetoothOn = state == BluetoothAdapterState.on;
      });
    });

    // Get the initial Bluetooth state
    FlutterBluePlus.adapterState.first.then((BluetoothAdapterState initialState) {
      setState(() {
        isBluetoothOn = initialState == BluetoothAdapterState.on;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    double horizontalPadding = screenWidth * 0.1;
    double buttonSpacing = screenHeight * 0.05;

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.grey[800]
          : Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth - 40;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: screenWidth * 0.8,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                      decoration: BoxDecoration(
                        color: themeProvider.accentColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'CONNECTION',
                          style: TextStyle(
                            color: themeProvider.accentColor == Colors.white ? Colors.black : Colors.white, // adjusts the text color only if the accent color is white
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: buttonSpacing),
                  _buildBluetoothStatusIndicator(maxWidth, screenWidth, themeProvider),
                  SizedBox(height: buttonSpacing),
                  if (!isBluetoothOn)
                    Center(
                      child: Text(
                        'Please turn on Bluetooth to connect your device to the LightUp Cane',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeProvider.accentColor,
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else ...[
                    SizedBox(height: buttonSpacing),
                    Text(
                      pairedDevices,
                      style: TextStyle(
                        color: themeProvider.accentColor,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildDeviceRow(cane1, connected, maxWidth, screenWidth, themeProvider),
                    SizedBox(height: screenHeight * 0.02),
                    _buildDeviceRow(cane2, '', maxWidth, screenWidth, themeProvider),
                    SizedBox(height: buttonSpacing),
                    Center(
                      child: CustomButton(
                        label: 'Connect to Cane',
                        onPressed: () {
                          // Add connection functionality here
                        },
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        color: themeProvider.accentColor,
                      ),
                    ),
                  ],
                  SizedBox(height: buttonSpacing),

                  Spacer(),
                  
                  SizedBox(height: buttonSpacing),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentPage: "Connection"),
    );
  }

  // Updated Bluetooth status indicator without interaction
  Widget _buildBluetoothStatusIndicator(double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return Container(
      width: maxWidth,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: themeProvider.themeMode == ThemeMode.dark
              ? Colors.grey[850]
              : Colors.grey[400],
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
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceRow(String deviceName, String connectionStatus, double maxWidth, double screenWidth, ThemeProvider themeProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: themeProvider.themeMode == ThemeMode.dark
              ? Colors.grey[850]
              : Colors.grey[400],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            deviceName,
            style: TextStyle(
              color: themeProvider.accentColor,
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            connectionStatus,
            style: TextStyle(
              color: connectionStatus.isNotEmpty ? themeProvider.accentColor : Colors.transparent,
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

//in pubspec.yaml change dependecies into below to make it work
//dependencies:
//  flutter:
//    sdk: flutter
//  flutter_blue_plus: ^1.34.4
