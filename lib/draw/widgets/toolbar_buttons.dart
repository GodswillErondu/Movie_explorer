import 'package:flutter/material.dart';
import 'package:movie_explorer_app/draw/providers/drawing_provider.dart';

class ToolbarButtons extends StatelessWidget {
  final DrawingProvider provider;
  final Color iconColor;
  final Color accentColor;
  final double screenWidth;

  const ToolbarButtons({
    super.key,
    required this.provider,
    required this.iconColor,
    required this.accentColor,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
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
}
