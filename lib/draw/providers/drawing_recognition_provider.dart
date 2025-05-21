import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as mlkit;

class DrawingRecognitionProvider extends ChangeNotifier {
  final mlkit.DigitalInkRecognizer _digitalInkRecognizer =
      mlkit.DigitalInkRecognizer(languageCode: 'en');
  final mlkit.DigitalInkRecognizerModelManager _modelManager =
      mlkit.DigitalInkRecognizerModelManager();
  final mlkit.Ink _ink = mlkit.Ink();
  List<mlkit.StrokePoint> _points = [];
  String _recognizedText = '';
  bool _isProcessing = false;
  bool _isModelDownloaded = false;
  List<mlkit.Stroke> _undoStack = [];

  mlkit.Ink get ink => _ink;

  List<mlkit.StrokePoint> get points => _points;

  String get recognizedText => _recognizedText;

  bool get isProcessing => _isProcessing;

  bool get isModelDownloaded => _isModelDownloaded;

  final repaintNotifier = ValueNotifier(false);


  DrawingRecognitionProvider() {
    _checkAndDownloadModel();
  }

  @override
  void dispose() {
    _digitalInkRecognizer.close();
    _ink.strokes.clear();
    _points.clear();
    _undoStack.clear();
    super.dispose();
  }

  Future<void> _checkAndDownloadModel() async {
    try {
      final bool modelExists = await _modelManager.isModelDownloaded('en');
      if (!modelExists) {
        _recognizedText = 'Downloading model...';
        _isProcessing = true;
        notifyListeners();
        await _modelManager.downloadModel('en');
      }
      _isModelDownloaded = true;
      _recognizedText = 'Ready to recognize';
      _isProcessing = false;
      notifyListeners();
    } catch (e) {
      _isModelDownloaded = false;
      _recognizedText = 'Error with model: ${e.toString()}';
      _isProcessing = false;
      notifyListeners();
      print('Model error: ${e.toString()}');
    }
  }

  void undoLastStroke() {
    if (_ink.strokes.isNotEmpty) {
      final lastStroke = _ink.strokes.removeLast();
      _undoStack.add(lastStroke);
      notifyListeners();
      _recognizeText();
    }
  }

  Future<void> _recognizeText() async {
    if (!_isModelDownloaded) {
      _recognizedText = 'Model not ready';
      notifyListeners();
      return;
    }

    if (_ink.strokes.isEmpty) {
      _recognizedText = 'Draw something';
      notifyListeners();
      return;
    }

    _isProcessing = true;
    notifyListeners();

    try {
      final List<mlkit.RecognitionCandidate> candidates =
          await _digitalInkRecognizer.recognize(_ink);

      _recognizedText =
          candidates.isNotEmpty ? candidates.first.text : 'No text recognized';
      _isProcessing = false;
      notifyListeners();
    } catch (e) {
      _recognizedText = 'Error recognizing text: ${e.toString()}';
      _isProcessing = false;
      notifyListeners();
      print('Recognition error: ${e.toString()}');
    }
  }

  void clearPad() {
    _ink.strokes.clear();
    _points = [];
    _recognizedText = '';
    _undoStack.clear();
    notifyListeners();
  }

  void startStroke(Offset position) {
    _points = [
      mlkit.StrokePoint(
        x: position.dx,
        y: position.dy,
        t: DateTime.now().millisecondsSinceEpoch,
      ),
    ];
    notifyListeners();
  }

  void updateStroke(Offset position) {
    _points.add(
      mlkit.StrokePoint(
        x: position.dx,
        y: position.dy,
        t: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    notifyListeners();
  }

  void endStroke() {
    if (_points.length > 1) {
      final stroke = mlkit.Stroke()..points.addAll(_points);
      _ink.strokes.add(stroke);
      _points = [];
      _undoStack.clear();
      notifyListeners();
      _recognizeText();
    }
  }
}
