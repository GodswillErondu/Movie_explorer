import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
as mlkit;

class DrawingPainter extends CustomPainter {
  final mlkit.Ink ink;
  final List<mlkit.StrokePoint> points;
  final bool isDarkMode;

  DrawingPainter({
    required this.ink,
    required this.points,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = isDarkMode ? Colors.white : Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    // Draw completed strokes
    for (final stroke in ink.strokes) {
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = stroke.points[i];
        final p2 = stroke.points[i + 1];
        canvas.drawLine(
          Offset(p1.x, p1.y),
          Offset(p2.x, p2.y),
          paint,
        );
      }
    }

    // Draw current stroke
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(
        Offset(points[i].x, points[i].y),
        Offset(points[i + 1].x, points[i + 1].y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}