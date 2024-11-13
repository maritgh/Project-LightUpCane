import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'theme_provider.dart';
import 'support_page.dart';
import 'bottom_nav_bar.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  // Variables to hold the status information
  String battery = '90%';
  String light = 'ON';
  String lightIntensity = 'LOW';
  String notifications = 'OFF';
  String hapticIntensity = '25%';
  String buzzerIntensity = '100%';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.black87
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
                    color: themeProvider.accentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'STATUS',
                      style: TextStyle(
                        color: themeProvider.accentColor == Colors.white ? Colors.black : Colors.white, // adjusts the text color only if the accent color is white
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
                        _buildDisplayRow('BATTERY', battery, maxWidth, screenWidth, themeProvider),
                        _buildDisplayRow('LIGHT', light, maxWidth, screenWidth, themeProvider),
                        _buildDisplayRow('NOTIFICATIONS', notifications, maxWidth, screenWidth, themeProvider),
                        _buildDisplayRow('LIGHT INTENSITY', lightIntensity, maxWidth, screenWidth, themeProvider),
                        _buildDisplayRow('HAPTIC INTENSITY', hapticIntensity, maxWidth, screenWidth, themeProvider),
                        _buildDisplayRow('BUZZER INTENSITY', buzzerIntensity, maxWidth, screenWidth, themeProvider),
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
    return Row(
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
            color: Colors.grey[400],
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
    );
  }
}

//in pubspec.yaml change dependecies into below to make it work
//dependencies:
//  flutter:
//    sdk: flutter
//  http: ^1.2.2
