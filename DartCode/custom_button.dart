import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double screenWidth;
  final double screenHeight;

  CustomButton({
    required this.label,
    required this.onPressed,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    double buttonWidth = screenWidth * 0.8;  // 80% of screen width
    double buttonHeight = screenHeight * 0.1; // 10% of screen height

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.1,  // Font size as 10% of screen width
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
