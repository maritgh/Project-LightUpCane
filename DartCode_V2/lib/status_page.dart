import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
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
  // Variables to hold the status information
  String battery = '';
  String light = '';
  String lightIntensity = '';
  String notifications = '';
  String hapticIntensity = '';
  String buzzerIntensity = '';
  String buzzerFrequency = '';

  Timer? _timer;

  Future<void> fetchStatusData() async {
    final url = Uri.parse("http://192.168.4.1/get");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<String> values = response.body.split(" ");
        if (values.length >= 6) {
          setState(() {
            battery = "${values[0]}%";
            light = values[5] == "1" ? S.of(context).on : S.of(context).off;
            lightIntensity = values[1] == "30" ? S.of(context).low : values[1] == "60" ? S.of(context).medium : S.of(context).high;
            hapticIntensity = "${values[4] == '0' ? 0 : values[4] == '70' ? 25 : values[4] == '80' ? 50 : values[4] == '90' ? 75 : 100}%";
            buzzerIntensity = "${values[2] == '0' ? 0 : values[2] == '1' ? 25 : values[2] == '3' ? 50 : values[2] == '5' ? 75 : 100}%";
            buzzerFrequency = "${values[3]}%";
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
