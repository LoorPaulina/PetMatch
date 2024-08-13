import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 10.0,
    this.elevation = 2.0,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: elevation, // Shadow elevation
        padding: padding, // Button padding
      ),
      child: Text(
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontFamily: 'LexendDeca'),
          text),
    );
  }
}
