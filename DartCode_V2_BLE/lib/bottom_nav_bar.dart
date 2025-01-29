import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'theme_provider.dart';
import 'status_page.dart';
import 'presets_page.dart';
import 'settings_cane_page.dart';
import 'settings_app_page.dart';

class BottomNavBar extends StatelessWidget {
  final String currentPage;

  BottomNavBar({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: themeProvider.themeMode == ThemeMode.dark
          ? Colors.grey[600]
          : Colors.grey[400],
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavButton(
              context,
              S.of(context).nav_status,
              currentPage == "Status",
              themeProvider,
              screenWidth,
              screenHeight,
              "Status"),
          _buildNavButton(
              context,
              S.of(context).nav_presets,
              currentPage == "Presets",
              themeProvider,
              screenWidth,
              screenHeight,
              "Presets"),
          _buildNavButton(
              context,
              S.of(context).nav_settings_cane,
              currentPage == "SettingsCane",
              themeProvider,
              screenWidth,
              screenHeight,
              "Settings\nCane"),
          _buildNavButton(
              context,
              S.of(context).nav_settings_app,
              currentPage == "SettingsApp",
              themeProvider,
              screenWidth,
              screenHeight,
              "Settings\nApp"),
        ],
      ),
    );
  }

  Widget _buildNavButton(
      BuildContext context,
      String label,
      bool isSelected,
      ThemeProvider themeProvider,
      double screenWidth,
      double screenHeight,
      String switchLabel) {
    final buttonWidth =
        screenWidth * 0.2; // Set each button to 20% of the screen width
    final buttonHeight =
        screenHeight * 0.07; // Set each button to 15% of the screen height

    return GestureDetector(
      onTap: () {
        // Navigate to corresponding page using MaterialPageRoute
        Widget page;
        switch (switchLabel) {
          case "Status":
            page = StatusPage(); // Replace with your actual Status page widget
            break;
          case "Presets":
            page =
                PresetsPage(); // Replace with your actual Presets page widget
            break;
          case "Settings\nCane":
            page =
                SettingsCanePage(); // Replace with your actual Settings Cane page widget
            break;
          case "Settings\nApp":
            page =
                SettingsAppPage(); // Replace with your actual Settings App page widget
            break;
          default:
            return; // If label doesn't match, do nothing
        }
        // Push the new page onto the stack
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: isSelected ? themeProvider.accentColor : Colors.grey[500],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label.replaceAll('\n', '\n'), // Format it as two lines
            textAlign: TextAlign.center, // Center text in each button
            style: TextStyle(
              color: themeProvider.accentColor == Colors.white
                  ? Colors.black
                  : Colors
                      .white, // adjusts the text color only if the accent color is white
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
