import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

import 'package:movie_explorer_app/models/stroke.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Stroke> _strokes = [];
  List<Stroke> _redoStrokes = [];
  List<Offset> _currentPoints = [];
  late Color _selectedColor;
  double _brushSize = 4.0;
  bool _isEraser = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    _selectedColor = isDarkMode ? Colors.white : Colors.black;
  }

  Color _getEraseColor() {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;
  }

  Color get _effectiveColor => _isEraser ? _getEraseColor() : _selectedColor;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Draw Your Dream',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
          onPressed: () => context.go('/'),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _currentPoints.add(details.localPosition);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  _currentPoints.add(details.localPosition);
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _strokes.add(
                    Stroke(
                      points: List.from(_currentPoints),
                      color: _effectiveColor, // Use effective color here
                      brushSize: _brushSize,
                    ),
                  );
                  _currentPoints = [];
                  _redoStrokes = [];
                });
              },
              child: CustomPaint(
                painter: DrawPainter(
                  strokes: _strokes,
                  currentPoints: _currentPoints,
                  currentColor: _effectiveColor, // Use effective color here
                  currentBrushSize: _brushSize,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          _buildToolBar()
        ],
      ),
    );
  }

  Widget _buildToolBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final toolbarPadding = (screenWidth * 0.04).clamp(8.0, 24.0);

    // Use theme-aware colors for better contrast
    final toolbarColor = isDarkMode
        ? Theme.of(context).colorScheme.surface.withOpacity(0.9)
        : Theme.of(context).colorScheme.surface;

    final iconColor = Theme.of(context).colorScheme.onSurface;
    final accentColor = Theme.of(context).colorScheme.primary;

    return Container(
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
          Row(
            children: [
              // undo button
              IconButton(
                onPressed: _strokes.isNotEmpty
                    ? () {
                        setState(() {
                          _redoStrokes.add(_strokes.removeLast());
                        });
                      }
                    : null,
                icon: Icon(Icons.undo, color: iconColor),
                iconSize: (screenWidth * 0.06).clamp(20.0, 32.0),
              ),

              // redo button
              IconButton(
                onPressed: _redoStrokes.isNotEmpty
                    ? () {
                        setState(() {
                          _strokes.add(_redoStrokes.removeLast());
                        });
                      }
                    : null,
                icon: Icon(Icons.redo, color: iconColor),
                iconSize: (screenWidth * 0.06).clamp(20.0, 32.0),
              ),

              // eraser button
              IconButton(
                onPressed: () {
                  setState(() {
                    _isEraser = !_isEraser;
                  });
                },
                icon: Icon(
                  Icons.auto_fix_normal,
                  color: _isEraser ? accentColor : iconColor,
                ),
                iconSize: (screenWidth * 0.06).clamp(20.0, 32.0),
              ),
            ],
          ),

          Theme(
            // Override dropdown theme for better visibility
            data: Theme.of(context).copyWith(
              dropdownMenuTheme: DropdownMenuThemeData(
                textStyle: TextStyle(
                  color: iconColor,
                  fontSize: (screenWidth * 0.035).clamp(12.0, 18.0),
                ),
              ),
            ),
            child: DropdownButton(
              value: _brushSize,
              dropdownColor: toolbarColor,
              icon: Icon(Icons.arrow_drop_down, color: iconColor),
              underline: Container(
                height: 2,
                color: accentColor,
              ),
              items: [
                DropdownMenuItem(
                  value: 4.0,
                  child: Text(
                    'Small',
                    style: TextStyle(
                      color: iconColor,
                      fontSize: (screenWidth * 0.035).clamp(12.0, 18.0),
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 8.0,
                  child: Text(
                    'Medium',
                    style: TextStyle(
                      color: iconColor,
                      fontSize: (screenWidth * 0.035).clamp(12.0, 18.0),
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 12.0,
                  child: Text(
                    'Large',
                    style: TextStyle(
                      color: iconColor,
                      fontSize: (screenWidth * 0.035).clamp(12.0, 18.0),
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _brushSize = value!;
                });
              },
            ),
          ),

          // Color picker
          Row(
            children: [
              _buildColorButton(Colors.black),
              _buildColorButton(Colors.white),
              _buildColorButton(Colors.red),
              _buildColorButton(Colors.blue),
              _buildColorButton(Colors.green),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDarkMode ? Colors.white : Colors.black;

    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate button size based on screen width
    // Use clamp to set min and max sizes
    final buttonSize = (screenWidth * 0.06).clamp(20.0, 32.0);
    final borderWidth = (screenWidth * 0.005).clamp(1.5, 3.0);
    final marginSize = (screenWidth * 0.01).clamp(2.0, 6.0);

    // Determine if this color button should be visible based on theme
    final isColorVisible = !((isDarkMode && color == Colors.black) ||
        (!isDarkMode && color == Colors.white));

    if (!isColorVisible) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
          _isEraser = false; // Turn off eraser when selecting a color
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: marginSize),
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: (_selectedColor == color && !_isEraser)
                ? borderColor
                : Colors.grey.withOpacity(0.3),
            width: borderWidth,
          ),
          // Add subtle shadow for better visibility
          boxShadow: [
            if (color == Colors.white && !isDarkMode)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: buttonSize * 0.08,
                spreadRadius: buttonSize * 0.04,
              ),
            if (color == Colors.black && isDarkMode)
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: buttonSize * 0.08,
                spreadRadius: buttonSize * 0.04,
              ),
          ],
        ),
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
    // Draw completed strokes
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

    // Draw the current active stroke
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
