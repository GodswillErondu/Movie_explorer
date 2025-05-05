import 'package:flutter/material.dart';
import 'package:movie_explorer_app/models/stroke.dart';

class DrawingProvider extends ChangeNotifier {
   List<Stroke> _strokes = [];
  List<Stroke> _redoStrokes = [];
  List<Offset> _currentPoints = [];
  Color? _selectedColor;
  double _brushSize = 4.0;
  bool _isEraser = false;

  // Getters
  List<Stroke> get strokes => _strokes;
  List<Stroke> get redoStrokes => _redoStrokes;
  List<Offset> get currentPoints => _currentPoints;
  Color? get selectedColor => _selectedColor;
  double get brushSize => _brushSize;
  bool get isEraser => _isEraser;
  bool get canUndo => _strokes.isNotEmpty;
  bool get canRedo => _redoStrokes.isNotEmpty;

  Color getEffectiveColor(BuildContext context) {
    if (_isEraser) {
      return Theme.of(context).scaffoldBackgroundColor;
    }
    if (_selectedColor == null) {
      return Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;
    }
    return _selectedColor!;
  }

  void addPoint(Offset point) {
    _currentPoints.add(point);
    notifyListeners();
  }

  void completeStroke(Color effectiveColor) {
    if (_currentPoints.isNotEmpty) {
      _strokes.add(
        Stroke(
          points: List.from(_currentPoints),
          color: effectiveColor,
          brushSize: _brushSize,
        ),
      );
      _currentPoints = [];
      _redoStrokes = [];
      notifyListeners();
    }
  }

  void undo() {
    if (canUndo) {
      _redoStrokes.add(_strokes.removeLast());
      notifyListeners();
    }
  }

  void redo() {
    if (canRedo) {
      _strokes.add(_redoStrokes.removeLast());
      notifyListeners();
    }
  }

  void toggleEraser() {
    _isEraser = !_isEraser;
    notifyListeners();
  }

  void setBrushSize(double size) {
    _brushSize = size;
    notifyListeners();
  }

  void setColor(Color color) {
    _selectedColor = color;
    _isEraser = false;
    notifyListeners();
  }

  void clearPoints() {
    _currentPoints = [];
    notifyListeners();
  }
}