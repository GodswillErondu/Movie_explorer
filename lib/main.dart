import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_explorer_app/core/router_config.dart';
import 'package:movie_explorer_app/draw/providers/drawing_recognition_provider.dart';
import 'package:movie_explorer_app/movie/providers/movie_provider.dart';
import 'package:movie_explorer_app/movie/services/movie_service.dart';
import 'package:movie_explorer_app/audio/providers/audio_player_provider.dart';
import 'package:movie_explorer_app/draw/providers/drawing_provider.dart';
import 'package:movie_explorer_app/audio/services/audio_service.dart';
import 'package:movie_explorer_app/core/theme.dart';
import 'package:movie_explorer_app/core/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_explorer_app/core/cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env',);

  CacheService? cacheService;
  try {
    cacheService = await CacheService.initialize();
  } catch (e) {
    await CacheService.clearAllBoxes();
    cacheService = await CacheService.initialize();
  }

  final movieService = MovieService(cacheService);
  final audioService = AudioService(cacheService);

  WidgetsBinding.instance.addObserver(
    LifecycleEventHandler(
      detached: () async {
        await cacheService?.dispose();
      },
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AudioPlayerProvider(audioService)),
        ChangeNotifierProvider(create: (_) => DrawingProvider()),
        ChangeNotifierProvider(create: (_) => DrawingRecognitionProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider(movieService)),
        Provider.value(value: movieService),
        Provider.value(value: audioService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeNotifier, child) {
        return MaterialApp.router(
          routerConfig: routerConfig, // Use the imported router config
          title: 'Movie Explorer',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeNotifier.effectiveThemeMode,
        );
      },
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? detached;

  LifecycleEventHandler({
    this.detached,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.detached:
        if (detached != null) {
          await detached!();
        }
        break;
      default:
        break;
    }
  }
}
