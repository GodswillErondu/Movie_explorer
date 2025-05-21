
import 'package:flutter/material.dart';
import 'package:movie_explorer_app/draw/providers/drawing_recognition_provider.dart';
import 'package:movie_explorer_app/draw/widgets/drawing_painter.dart';
import 'package:provider/provider.dart';

class DrawingRecognitionScreen extends StatelessWidget {
  final bool isFromAudioSearch;


   const DrawingRecognitionScreen({super.key, this.isFromAudioSearch = false,});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DrawingRecognitionProvider>(context,);
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;


    void submitRecognizedText() {
      if(provider.recognizedText.isNotEmpty && provider.recognizedText != 'No text recognized') {
        Navigator.pop(context, provider.recognizedText);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Text Recognition',
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          if (isFromAudioSearch)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: provider.isProcessing ? null : submitRecognizedText,
            color: theme.colorScheme.onSurface,
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: provider.ink.strokes.isNotEmpty ? provider.undoLastStroke : null,
            color: theme.colorScheme.onSurface,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: provider.clearPad,
            color: theme.colorScheme.onSurface,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          // Drawing Area
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.dividerColor,
                ),
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              child: GestureDetector(
                onPanStart: (details) {
                  provider.startStroke(details.localPosition);
                },
                onPanUpdate: (details) {
                 provider.updateStroke(details.localPosition);
                 provider.repaintNotifier.value = !provider.repaintNotifier.value;
                },
                onPanEnd: (details) {
                 provider.endStroke();
                },
                child: Consumer<DrawingRecognitionProvider>(
                  builder: (context, provider, _) {
                    return CustomPaint(
                      painter: DrawingPainter(
                        repaintNotifier: provider.repaintNotifier,
                        ink: provider.ink,
                        points: provider.points,
                        isDarkMode: isDarkMode,
                      ),
                      size: Size.infinite,
                    );
                  }
                ),
              ),
            ),
          ),
          Consumer<DrawingRecognitionProvider>(
            builder: (context, provider, _) {
              return Container(
                height: 100,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(color: theme.dividerColor),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: provider.isProcessing ? 0.5 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        provider.recognizedText.isEmpty && provider.isProcessing
                            ? 'Processing...'
                            : provider.recognizedText,
                        style: theme
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (provider.isProcessing)
                      Positioned(
                        right: 0,
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}


