import 'package:flutter/material.dart';

abstract class DrawingConstants {
  static const List<Color> availableColors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
  ];

  static const double defaultBrushSize = 4.0;
  static const List<double> brushSizes = [4.0, 8.0, 12.0];
  static const List<String> brushSizeLabels = ['Small', 'Medium', 'Large'];
}