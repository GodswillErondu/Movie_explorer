import 'package:flutter/material.dart';
import 'package:movie_explorer_app/draw/providers/drawing_provider.dart';
import 'package:movie_explorer_app/draw/widgets/brush_size_dropdown.dart';
import 'package:movie_explorer_app/draw/widgets/color_picker.dart';
import 'package:movie_explorer_app/draw/widgets/toolbar_buttons.dart';
import 'package:provider/provider.dart';


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
        ToolbarButtons(
            provider: provider,
            iconColor: iconColor,
            accentColor: accentColor,
            screenWidth: screenWidth,
        ),
        BrushSizeDropdown(
          provider: provider,
          backgroundColor: toolbarColor,
          textColor: iconColor,
          accentColor: accentColor,
          screenWidth: screenWidth,
        ),
        ColorPicker(
            provider: provider,
            isDarkMode: isDarkMode,
            screenWidth: screenWidth),
      ],
    ),
  );
}




}