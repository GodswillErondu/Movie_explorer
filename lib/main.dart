import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_explorer_app/navigation/router_config.dart';
import 'package:movie_explorer_app/providers/audio_player_provider.dart';
import 'package:movie_explorer_app/services/audio_service.dart';
import 'package:movie_explorer_app/theme/theme.dart';
import 'package:movie_explorer_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_explorer_app/services/cache_service.dart';
import 'package:movie_explorer_app/services/movie_service.dart';

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
        ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
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
