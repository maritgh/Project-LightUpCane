import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'generated/l10n.dart';
import 'theme_provider.dart';
import 'bottom_nav_bar.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  bool isBluetoothOn = false;
  List<ScanResult> scanResults = []; // List to store scanned Bluetooth devices
  List<BluetoothDevice> connectedDevices = []; // List to store connected devices
  late StreamSubscription<BluetoothAdapterState> bluetoothSubscription; // Subscription for Bluetooth state changes

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      checkBluetoothSupport(); // Check if Bluetooth is supported
    }
    fetchConnectedDevices(); // Retrieve previously connected devices
  }

  @override
  void dispose() {
    bluetoothSubscription.cancel(); // Cancel the subscription to avoid memory leaks
    super.dispose();
  }

  // Checks if Bluetooth is supported on the device
  Future<void> checkBluetoothSupport() async {
    await _checkPermissions(); // Ensure required permissions are granted
    bool supported = await FlutterBluePlus.isSupported;
    if (!supported) {
      setState(() {
        isBluetoothOn = false;
      });
      print("Bluetooth not supported by this device");
      return;
    }
    handleBluetoothState(); // Handle Bluetooth state updates
  }

  // Requests necessary permissions for Bluetooth operations
  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    if (!allGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bluetooth permissions are required for scanning")),
      );
    }
  }

  // Handles Bluetooth adapter state changes
  void handleBluetoothState() {
    bluetoothSubscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      setState(() {
        isBluetoothOn = state == BluetoothAdapterState.on;
        if (isBluetoothOn) {
          startScanForDevices(); // Start scanning when Bluetooth is on
        }
      });
    });

    // Check initial Bluetooth state
    FlutterBluePlus.adapterState.first.then((BluetoothAdapterState initialState) {
      setState(() {
        isBluetoothOn = initialState == BluetoothAdapterState.on;
        if (isBluetoothOn) {
          startScanForDevices();
        }
      });
    });
  }

  // Starts scanning for nearby Bluetooth devices
  void startScanForDevices() {
    scanResults.clear(); // Clear previous scan results
    setState(() {});

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4)); // Start scanning for 4 seconds

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        // Filter out devices that do not have a local name
        scanResults = results
            .where((result) => result.advertisementData.localName.isNotEmpty)
            .toList();
      });
    });
  }

  // Connects to a selected Bluetooth device
  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false); // Attempt to connect
      setState(() {
        connectedDevices.add(device); // Add the device to the connected list
      });
      print('Connected to ${device.name}');

      // Announce successful connection for accessibility support
      String connectSuccess = S.of(context).connected_successfully;
      SemanticsService.announce(
        '${device.name.isNotEmpty ? device.name : "Unnamed Device"} $connectSuccess',
        TextDirection.ltr,
      );
    } catch (e) {
      print("Error connecting to device: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error connecting to device: $e")),
      );
    }
  }

  // Fetches the list of currently connected Bluetooth devices
  void fetchConnectedDevices() async {
    List<BluetoothDevice> devices = FlutterBluePlus.connectedDevices;
    setState(() {
      connectedDevices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.grey[800]
          : Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Center(
                child: Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  decoration: BoxDecoration(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.grey[850]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      S.of(context).connection,
                      style: TextStyle(
                        color: themeProvider.accentColor,
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bluetooth Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.grey[850]
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.bluetooth, color: themeProvider.accentColor),
                    SizedBox(width: screenWidth * 0.05),
                    Text(
                      isBluetoothOn ? S.of(context).bluetooth_on : S.of(context).bluetooth_off,
                      style: TextStyle(
                        color: themeProvider.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Connected Devices
              Text(
                S.of(context).connected_devices,
                style: TextStyle(
                  color: themeProvider.accentColor,
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Expanded(
                child: ListView(
                  children: connectedDevices.map((device) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.grey[850]
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        device.name.isNotEmpty ? device.name : 'Unnamed Device',
                        style: TextStyle(
                          color: themeProvider.accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Available Devices
              Text(
                S.of(context).available_devices,
                style: TextStyle(
                  color: themeProvider.accentColor,
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Expanded(
                child: ListView(
                  children: scanResults.map((result) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.grey[850]
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Semantics(
                        label: "${result.device.name.isNotEmpty ? result.device.name : 'Unnamed Device'}, ${S.of(context).connect}",
                        excludeSemantics: true,
                        button: true,
                        child: InkWell(
                          onTap: () => connectToDevice(result.device),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  result.device.name.isNotEmpty
                                      ? result.device.name
                                      : 'Unnamed Device',
                                  style: TextStyle(
                                    color: themeProvider.accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => connectToDevice(result.device),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text(S.of(context).connect),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentPage: "Connection"),
    );
  }
}
