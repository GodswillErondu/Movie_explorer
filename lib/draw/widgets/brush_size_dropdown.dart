import 'package:flutter/material.dart';
import 'package:movie_explorer_app/core/constants/drawing_constants.dart';
import 'package:movie_explorer_app/draw/providers/drawing_provider.dart';

class BrushSizeDropdown extends StatelessWidget {
  final DrawingProvider provider;
  final Color backgroundColor;
  final Color textColor;
  final Color accentColor;
  final double screenWidth;

  const BrushSizeDropdown({
    super.key,
    required this.provider,
    required this.backgroundColor,
    required this.textColor,
    required this.accentColor,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = (screenWidth * 0.035).clamp(12.0, 18.0);

    return Theme(
      data: theme.copyWith(
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: textColor, fontSize: fontSize),
        ),
      ),
      child: DropdownButton<double>(
          value: provider.brushSize,
          dropdownColor: backgroundColor,
          icon: Icon(Icons.arrow_drop_down, color: textColor),
          underline: Container(height: 2, color: accentColor),
          items: List.generate(
            DrawingConstants.brushSizes.length,
                (index) => DropdownMenuItem(
              value: DrawingConstants.brushSizes[index],
              child: Text(
                DrawingConstants.brushSizeLabels[index],
                style: TextStyle(color: textColor, fontSize: fontSize),
              ),
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              provider.setBrushSize(value);
            }
          }
      ),
    );
  }
}
