import 'package:flutter/material.dart';

class CityMapConstants {
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Color(0xFF4285F4);
  static const Color backgroundColor = Colors.white;
  static const Color errorColor = Colors.red;

  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Map styling
  static const double defaultZoom = 10.0;
  static const double mapPadding = 50.0;

  // Input decoration
  static InputDecoration textFieldDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }
}