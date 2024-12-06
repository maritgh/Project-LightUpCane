import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'theme_provider.dart';
import 'bottom_nav_bar.dart';

class SupportPage extends StatelessWidget {
  SupportPage({Key? key}) : super(key: key) {
    _initializeTts(); // Initialize TTS before speaking
  }

  final FlutterTts flutterTts = FlutterTts();

  // Method to initialize TTS
  Future<void> _initializeTts() async {
    await flutterTts.awaitSpeakCompletion(true); // Wait until completion of each utterance
    await flutterTts.setLanguage("en-US"); // Set language
    await flutterTts.setSpeechRate(0.5); // Set speech rate
    await flutterTts.setVolume(1.0); // Set volume
    await flutterTts.setPitch(1.0); // Set pitch
  }

  // Method to speak a given text
  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
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

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.grey[800]
          : Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Support Title
              Center(
                child: Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                  decoration: BoxDecoration(
                    color: themeProvider.themeMode == ThemeMode.dark
                        ? Colors.grey[850]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(20), // Rounded corners for title
                  ),
                  child: Center(
                    child: Text(
                      'SUPPORT',
                      style: TextStyle(
                        color: themeProvider.accentColor, // Use accent color from ThemeProvider
                        fontSize: screenWidth * 0.07, // Dynamic font size based on screen width
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: buttonSpacing), // Space between header and buttons

              // Support Options (APP, PRESETS, SETTINGS, STATUS)
              _buildSupportOption('APP', Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption('PRESETS', Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption('SETTINGS CANE', Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption('SETTINGS APP', Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption('STATUS', Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons

              // Contact Option at the bottom
              _buildContactOption('CONTACT', Icons.phone, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Spacing before the return button
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentPage: "Support"),
    );
  }

  // Method to build each support option row (App, Presets, etc.)
  Widget _buildSupportOption(String label, IconData icon, double screenWidth, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: themeProvider.accentColor,
              fontSize: screenWidth * 0.045, // Increased font size for better visibility
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            String textToSay = '';
            switch (label) {
              case 'APP':
                textToSay = 'The Light Up Cane app is an app in which the user can manage the settings of their connected cane. These settings are divided into the pages presets settings cane settings app and status. From every page you have the possibility to go to the previously listed pages.';
              case 'PRESETS':
                textToSay = 'The presets page shows the currently saved presets of your app and a save button that allows you to give a name and save all of your current settings under that name. When a preset is selected you get the options to select the settings of that preset delete the preset rename the preset or go back to the preset list.';
              case 'SETTINGS CANE':
                textToSay = 'The settings cane page has two subpages, audio and light. On the audio page you can select if you want to receive notifications and you can turn on or off and select the intensities of the haptic and buzzer that are located in the cane. On the light page you can turn the light of the cane on or off and select the intensity of the light.';
              case 'SETTINGS APP':
                textToSay = 'The settings app page has two subpages, theme and connection. On the theme page you can select themes and accents that will be used throughout the app. On the connection, if your bluetooth is turned on, you can select a cane that you want to connect with.';
              case 'STATUS':
                textToSay = 'The status page shows the current status of your connected cane, including battery level, light and notifications status, light haptic and buzzer intensities. The information updates every few seconds to keep you up-to-date. Only through the status page can you get to the support page.';
            }
            print("TTS Speaking: $textToSay"); // Debugging output
            await _speak(textToSay); // Ensure the method is awaited
          },
          child: Icon(
            icon,
            color: Colors.black,
            size: screenWidth * 0.07,
          ),
        ),
      ],
    );
  }

  // Method to build the contact row at the bottom
  Widget _buildContactOption(String label, IconData icon, double screenWidth, ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: themeProvider.accentColor,
              fontSize: screenWidth * 0.045, // Increased font size for better visibility
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Icon(
          icon,
          color: Colors.black,
          size: screenWidth * 0.07, // Increased icon size for better visibility
        ),
      ],
    );
  }
}

//in pubspec.yaml change dependecies into below to make it work
//dependencies:
//  flutter:
//    sdk: flutter
//  flutter_tts: ^4.1.0
