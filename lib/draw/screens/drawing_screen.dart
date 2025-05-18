import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:movie_explorer_app/draw/providers/drawing_provider.dart';
import 'package:movie_explorer_app/draw/widgets/draw_painter.dart';
import 'package:movie_explorer_app/draw/widgets/drawing_toolbar.dart';
import 'package:provider/provider.dart';

class DrawingScreen extends StatelessWidget {
  const DrawingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final drawingProvider = context.watch<DrawingProvider>();
    final isDarkMode = theme.brightness == Brightness.dark;
    final effectiveColor = drawingProvider.getEffectiveColor(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Draw Your Dream',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                drawingProvider.addPoint(details.localPosition);
              },
              onPanUpdate: (details) {
                drawingProvider.addPoint(details.localPosition);
              },
              onPanEnd: (_) {
                drawingProvider.completeStroke(effectiveColor);
              },
              child: CustomPaint(
                painter: DrawPainter(
                  strokes: drawingProvider.strokes,
                  currentPoints: drawingProvider.currentPoints,
                  currentColor: effectiveColor,
                  currentBrushSize: drawingProvider.brushSize,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          const DrawingToolbar(),
        ],
      ),
    );
  }
}


