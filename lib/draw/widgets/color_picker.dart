import 'package:flutter/material.dart';
import 'package:movie_explorer_app/core/constants/drawing_constants.dart';
import 'package:movie_explorer_app/draw/providers/drawing_provider.dart';

class ColorPicker extends StatelessWidget {
  final DrawingProvider provider;
  final bool isDarkMode;
  final double screenWidth;

  const ColorPicker({
    super.key,
    required this.provider,
    required this.isDarkMode,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: DrawingConstants.availableColors
          .where((color) => _isColorVisible(color, isDarkMode))
          .map((color) => _buildColorButton(
                context,
                provider,
                color,
                isDarkMode,
                screenWidth,
              ))
          .toList(),
    );
  }
}

bool _isColorVisible(Color color, bool isDarkMode) {
  return !((isDarkMode && color == Colors.black) ||
      (!isDarkMode && color == Colors.white));
}

Widget _buildColorButton(
  BuildContext context,
  DrawingProvider provider,
  Color color,
  bool isDarkMode,
  double screenWidth,
) {
  final borderColor = isDarkMode ? Colors.white : Colors.black;
  final buttonSize = (screenWidth * 0.06).clamp(20.0, 32.0);
  final borderWidth = (screenWidth * 0.005).clamp(1.5, 3.0);
  final marginSize = (screenWidth * 0.01).clamp(2.0, 6.0);

  return GestureDetector(
    onTap: () => provider.setColor(color),
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: marginSize),
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: (provider.selectedColor == color && !provider.isEraser)
              ? borderColor
              : Colors.grey.withOpacity(0.3),
          width: borderWidth,
        ),
        boxShadow: _getColorButtonShadow(color, isDarkMode, buttonSize),
      ),
    ),
  );
}

List<BoxShadow> _getColorButtonShadow(
    Color color, bool isDarkMode, double size) {
  if (color == Colors.white && !isDarkMode) {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: size * 0.08,
        spreadRadius: size * 0.04,
      )
    ];
  }
  if (color == Colors.black && isDarkMode) {
    return [
      BoxShadow(
        color: Colors.white.withOpacity(0.1),
        blurRadius: size * 0.08,
        spreadRadius: size * 0.04,
      )
    ];
  }
  return [];
}
