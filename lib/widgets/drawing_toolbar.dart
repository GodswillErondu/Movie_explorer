import 'package:flutter/material.dart';
import 'package:movie_explorer_app/providers/drawing_provider.dart';
import 'package:provider/provider.dart';

import '../core/constants/drawing_constants.dart';

class DrawingToolbar extends StatelessWidget {
  const DrawingToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DrawingProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final toolbarPadding = (screenWidth * 0.04).clamp(8.0, 24.0);

    final theme = Theme.of(context);
    final toolbarColor = theme.colorScheme.surface.withOpacity(0.9);
    final iconColor = theme.colorScheme.onSurface;
    final accentColor =theme.colorScheme.primary;

    return  Container(
    padding: EdgeInsets.symmetric(
        horizontal: toolbarPadding, vertical: toolbarPadding * 0.5),
    decoration: BoxDecoration(
      color: toolbarColor,
      boxShadow: [
        BoxShadow(
          color: isDarkMode
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, -1),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildToolButtons(context, provider, iconColor, accentColor, screenWidth),
        _buildBrushSizeDropdown(context, provider, toolbarColor, iconColor, accentColor, screenWidth),
        _buildColorPicker(context, provider, isDarkMode, screenWidth),
      ],
    ),
  );
}

  Widget _buildToolButtons(
      BuildContext context,
      DrawingProvider provider,
      Color iconColor,
      Color accentColor,
      double screenWidth,
      ) {
    final iconSize = (screenWidth * 0.06).clamp(20.0, 32.0);

    return Row(
      children: [
        IconButton(
          onPressed: provider.canUndo ? provider.undo : null,
          icon: Icon(Icons.undo, color: iconColor),
          iconSize: iconSize,
        ),
        IconButton(
          onPressed: provider.canRedo ? provider.redo : null,
          icon: Icon(Icons.redo, color: iconColor),
          iconSize: iconSize,
        ),
        IconButton(
          onPressed: provider.toggleEraser,
          icon: Icon(
            Icons.auto_fix_normal,
            color: provider.isEraser ? accentColor : iconColor,
          ),
          iconSize: iconSize,
        ),
      ],
    );
  }


  Widget _buildBrushSizeDropdown(
      BuildContext context,
      DrawingProvider provider,
      Color backgroundColor,
      Color textColor,
      Color accentColor,
      double screenWidth,
      ) {
    final fontSize = (screenWidth * 0.035).clamp(12.0, 18.0);

    return Theme(
      data: Theme.of(context).copyWith(
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
  Widget _buildColorPicker(
      BuildContext context,
      DrawingProvider provider,
      bool isDarkMode,
      double screenWidth,
      ) {
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

  List<BoxShadow> _getColorButtonShadow(Color color, bool isDarkMode, double size) {
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

}