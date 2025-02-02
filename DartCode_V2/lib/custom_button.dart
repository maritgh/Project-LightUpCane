import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double screenWidth;
  final double screenHeight;
  final Color color; // Button color

  CustomButton({
    required this.label,
    required this.onPressed,
    required this.screenWidth,
    required this.screenHeight,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider
    Color buttonTextColor = themeProvider.accentColor; // Use accent color from ThemeProvider

    return SizedBox(
      width: screenWidth * 0.8, // Set width for the button
      height: screenHeight * 0.08, // Set height for the button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.7), // Add grey filter (transparency)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: buttonTextColor, // Use dynamic text color
            fontSize: screenWidth * 0.07, // Adjust text size
          ),
        ),
      ),
    );
  }
}
