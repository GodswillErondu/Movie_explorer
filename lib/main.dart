import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_explorer_app/providers/audio_player_provider.dart';
import 'package:movie_explorer_app/screens/main_screen.dart';
import 'package:movie_explorer_app/screens/movie_screen.dart';
import 'package:movie_explorer_app/services/audio_service.dart';
import 'package:movie_explorer_app/theme/theme.dart';
import 'package:movie_explorer_app/providers/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:movie_explorer_app/services/cache_service.dart';
import 'package:movie_explorer_app/services/movie_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  final cacheService = await CacheService.initialize();
  final movieService = MovieService(cacheService);
  final audioService = AudioService(cacheService);

  WidgetsBinding.instance.addObserver(
    LifecycleEventHandler(
      detached: () async {
        await cacheService.dispose();
      },
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
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
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: 'Movie Explorer',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeNotifier.effectiveThemeMode,
          home: const MainScreen(),
        );
      },
    );
  }
}

// Add this class to handle lifecycle events
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
