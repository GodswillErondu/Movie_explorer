import 'package:flutter/material.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as mlkit;

class DrawingRecognitionScreen extends StatefulWidget {
  const DrawingRecognitionScreen({super.key});

  @override
  State<DrawingRecognitionScreen> createState() =>
      _DrawingRecognitionScreenState();
}

class _DrawingRecognitionScreenState extends State<DrawingRecognitionScreen> {
  final mlkit.DigitalInkRecognizer _digitalInkRecognizer =
      mlkit.DigitalInkRecognizer(languageCode: 'en');
  final mlkit.DigitalInkRecognizerModelManager _modelManager =
      mlkit.DigitalInkRecognizerModelManager();
  final mlkit.Ink _ink = mlkit.Ink();
  List<mlkit.StrokePoint> _points = [];
  String _recognizedText = '';
  bool _isProcessing = false;
  bool _isModelDownloaded = false;
  List<mlkit.Stroke> _undoStack = []; // Add undo stack

  void _undoLastStroke() {
    if (_ink.strokes.isNotEmpty) {
      setState(() {
        // Remove the last stroke and add it to undo stack
        final lastStroke = _ink.strokes.removeLast();
        _undoStack.add(lastStroke);
        // Trigger recognition after undo
        _recognizeText();
      });
    }
  }

  @override
  void initState() {
    super.initState();
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
        setState(() {
          _recognizedText = 'Downloading model...';
          _isProcessing = true;
        });
        await _modelManager.downloadModel('en');
      }
      setState(() {
        _isModelDownloaded = true;
        _recognizedText = 'Ready to recognize';
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isModelDownloaded = false;
        _recognizedText = 'Error with model: ${e.toString()}';
        _isProcessing = false;
      });
      print('Model error: ${e.toString()}');
    }
  }

  Future<void> _recognizeText() async {
    if (!_isModelDownloaded) {
      setState(() {
        _recognizedText = 'Model not ready';
      });
      return;
    }

    if (_ink.strokes.isEmpty) {
      setState(() {
        _recognizedText = 'Draw something';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final List<mlkit.RecognitionCandidate> candidates =
          await _digitalInkRecognizer.recognize(_ink);

      setState(() {
        _recognizedText = candidates.isNotEmpty
            ? candidates.first.text
            : 'No text recognized';
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _recognizedText = 'Error recognizing text: ${e.toString()}';
        _isProcessing = false;
      });
      print('Recognition error: ${e.toString()}');
    }
  }

  void _clearPad() {
    setState(() {
      _ink.strokes.clear();
      _points = [];
      _recognizedText = '';
      _undoStack.clear(); // Clear undo stack when clearing pad
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Text Recognition',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _ink.strokes.isNotEmpty ? _undoLastStroke : null,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearPad,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Drawing Area
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                    ),
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                  child: GestureDetector(
                    onPanStart: (details) {
                      _points = [
                        mlkit.StrokePoint(
                          x: details.localPosition.dx,
                          y: details.localPosition.dy,
                          t: DateTime.now().millisecondsSinceEpoch,
                        ),
                      ];
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        _points.add(
                          mlkit.StrokePoint(
                            x: details.localPosition.dx,
                            y: details.localPosition.dy,
                            t: DateTime.now().millisecondsSinceEpoch,
                          ),
                        );
                      });
                    },
                    onPanEnd: (details) {
                      if (_points.length > 1) {
                        final stroke = mlkit.Stroke()..points.addAll(_points);
                        _ink.strokes.add(stroke);
                        _points = [];
                        _undoStack.clear();
                        _recognizeText();
                      }
                    },
                    child: CustomPaint(
                      painter: DrawingPainter(
                        ink: _ink,
                        points: _points,
                        isDarkMode: isDarkMode,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
              // Recognition Results Area
              Container(
                height: 100,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    top: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: Center(
                  child: _isProcessing
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Text(
                          _recognizedText,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                ),
              ),
            ],
          ),
          if (_isProcessing)
            Container(
              color: isDarkMode ? Colors.black54 : Colors.white54,
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

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
