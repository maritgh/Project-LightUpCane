import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'generated/l10n.dart';
import 'theme_provider.dart';
import 'bottom_nav_bar.dart';

class SupportPage extends StatelessWidget {
  SupportPage({Key? key}) : super(key: key);

  final FlutterTts flutterTts = FlutterTts();

  // Method to initialize TTS
  Future<void> _initializeTts(BuildContext context) async {
    await flutterTts.awaitSpeakCompletion(true); // Wait for completion of each utterance

    // Get the current locale
    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;
    String countryCode = currentLocale.countryCode ?? '';

    // Combine language code and country code
    String ttsLanguage = '$languageCode${countryCode.isNotEmpty ? '-$countryCode' : ''}';

    // Set the language for TTS
    var isLanguageAvailable = await flutterTts.isLanguageAvailable(ttsLanguage);
    if (isLanguageAvailable) {
      await flutterTts.setLanguage(ttsLanguage);
    } else {
      // Fallback to default language
      await flutterTts.setLanguage("en-US");
    }

    // Set additional TTS properties
    await flutterTts.setSpeechRate(0.5); // Set speech rate
    await flutterTts.setVolume(1.0); // Set volume
    await flutterTts.setPitch(1.0); // Set pitch
  }


  // Method to speak a given text
  Future<void> _speak(BuildContext context, String text) async {
    await _initializeTts(context); // Ensure the TTS language matches the current locale
    await flutterTts.speak(text); // Speak the provided text
  }


  @override
  Widget build(BuildContext context) {
     _initializeTts(context);

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
                      S.of(context).support,
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

              // Support Options
              _buildSupportOption(context, S.of(context).app, Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption(context, S.of(context).presets, Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption(context, S.of(context).settings_cane, Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption(context, S.of(context).settings_app, Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons
              _buildSupportOption(context, S.of(context).status, Icons.volume_up, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing), // Space between buttons

              // Contact Option at the bottom
              _buildContactOption(S.of(context).contact, Icons.phone, screenWidth, themeProvider),
              SizedBox(height: buttonSpacing),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentPage: "Support"),
    );
  }

  // Method to build each support option row
  Widget _buildSupportOption(BuildContext context, String label, IconData icon, double screenWidth, ThemeProvider themeProvider) {
    String iconText = S.of(context).support;
    return Semantics(
      label: "$label: $iconText",
      excludeSemantics: true,
      onTap: () async {
        String textToSay = _getTextToSay(context, label);
        await _speak(context, textToSay);
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
          GestureDetector(
            onTap: () async {
              String textToSay = _getTextToSay(context, label);
              await _speak(context, textToSay);
            },
            child: Icon(
              icon,
              color: Colors.black,
              size: screenWidth * 0.07,
            ),
          ),
        ],
      ),
    );
  }

  String _getTextToSay(BuildContext context, String label) {
    switch (label) {
      case 'APP':
        return S.of(context).explanation_app;
      case 'PRESETS':
        return S.of(context).explanation_presets;
      case 'SETTINGS CANE':
        return S.of(context).explanation_settings_cane;
      case 'SETTINGS APP':
        return S.of(context).explanation_settings_app;
      case 'STATUS':
        return S.of(context).explanation_status;
      default:
        return 'No information available.';
    }
  }

  // Method to build the contact row at the bottom
  Widget _buildContactOption(String label, IconData icon, double screenWidth, ThemeProvider themeProvider) {
    return Semantics(
      label: label,
      excludeSemantics: true,
      onTap: () {
        // Example contact action
        print("Contacting Support...");
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
          GestureDetector(
            onTap: () async {
              // Example contact action
              print("Contacting Support...");
            },
            child: Icon(
              icon,
              color: Colors.black,
              size: screenWidth * 0.07,
            ),
          ),
        ],
      ),
    );
  }
}
