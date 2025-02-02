import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'theme_provider.dart';
import 'bottom_nav_bar.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Get screen dimensions for dynamic scaling
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    double horizontalPadding = screenWidth * 0.1; // 10% padding

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
              // Language Title
              Center(
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
                      S.of(context).language,
                      style: TextStyle(
                        color: themeProvider.accentColor, // Use accent color from ThemeProvider
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03), // Space between title and content

              // Languages Section
              Text(
                S.of(context).languages,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.accentColor,
                ),
              ),
              fullWidthButton(
                S.of(context).dutch,
                    () => themeProvider.setLocale(Locale('nl')), // Change language to Dutch
                themeProvider.locale.languageCode == 'nl' ? themeProvider.accentColor : Colors.grey,
                screenWidth,
              ),
              fullWidthButton(
                S.of(context).english,
                    () => themeProvider.setLocale(Locale('en')), // Change language to English
                themeProvider.locale.languageCode == 'en' ? themeProvider.accentColor : Colors.grey,
                screenWidth,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentPage: "Theme"),
    );
  }

  // Helper method to generate accent color buttons
  Widget accentButton(String label, Color color, ThemeProvider themeProvider, double screenWidth) {
    return fullWidthButton(
      label,
      () => themeProvider.setAccentColor(color),
      themeProvider.accentColor == color ? themeProvider.accentColor : Colors.grey,
      screenWidth,
    );
  }

  // Helper method to create full-width buttons
  Widget fullWidthButton(String label, VoidCallback onPressed, Color textColor, double screenWidth) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.centerLeft,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
