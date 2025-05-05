import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

import 'package:movie_explorer_app/models/stroke.dart';
import 'package:movie_explorer_app/providers/drawing_provider.dart';
import 'package:movie_explorer_app/widgets/drawing_toolbar.dart';
import 'package:provider/provider.dart';

class DrawingScreen extends StatelessWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrawingProvider(),
      child: const _DrawingScreenContent(),
    );
  }
}

class _DrawingScreenContent extends StatelessWidget {
  const _DrawingScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawingProvider = context.watch<DrawingProvider>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = drawingProvider.getEffectiveColor(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Draw Your Dream',
          style: Theme.of(context).appBarTheme.titleTextStyle,
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

class DrawPainter extends CustomPainter {
  final List<Stroke> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentBrushSize;

  DrawPainter({
    required this.strokes,
    required this.currentPoints,
    required this.currentColor,
    required this.currentBrushSize,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke.brushSize;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        if (stroke.points[i] != Offset.zero &&
            stroke.points[i + 1] != Offset.zero) {
          canvas.drawLine(stroke.points[i]!, stroke.points[i + 1]!, paint);
        }
      }
    }

    final currentPaint = Paint()
      ..color = currentColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = currentBrushSize;

    for (int i = 0; i < currentPoints.length - 1; i++) {
      if (currentPoints[i] != Offset.zero &&
          currentPoints[i + 1] != Offset.zero) {
        canvas.drawLine(currentPoints[i], currentPoints[i + 1], currentPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}