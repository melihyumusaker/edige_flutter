// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomDecorations {
  static BoxDecoration buildGradientBoxDecoration(
      Color startColor, Color endColor) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [startColor, endColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }
}

