import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_explorer_app/models/movie.dart';
import 'package:movie_explorer_app/screens/movie_details_screen.dart';
import 'package:movie_explorer_app/services/movie_service.dart';
import 'package:movie_explorer_app/providers/theme_notifier.dart';
import 'package:movie_explorer_app/widgets/cached_movie_image.dart';
import 'package:provider/provider.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  late Future<List<Movie>> nowShowingMovies;
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> upcomingMovies;
  late MovieService _movieService;

  @override
  void initState() {
    super.initState();
    _movieService = Provider.of<MovieService>(context, listen: false);
    _initializeMovieData();
  }

  void _initializeMovieData() {
    nowShowingMovies = _movieService.getNowShowingMovies();
    popularMovies = _movieService.getPopularMovies();
    upcomingMovies = _movieService.getUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Explorer',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) {
              return PopupMenuButton<ThemeModeOption>(
                icon: Icon(
                  themeNotifier.currentIcon,
                  color: Theme.of(context).appBarTheme.actionsIconTheme?.color,
                ),
                offset: const Offset(0, 40),
                itemBuilder: (BuildContext context) => [
                  _buildThemeMenuItem(
                    context,
                    ThemeModeOption.system,
                    'System',
                    themeNotifier,
                  ),
                  _buildThemeMenuItem(
                    context,
                    ThemeModeOption.light,
                    'Light',
                    themeNotifier,
                  ),
                  _buildThemeMenuItem(
                    context,
                    ThemeModeOption.dark,
                    'Dark',
                    themeNotifier,
                  ),
                ],
                onSelected: (ThemeModeOption selectedTheme) {
                  themeNotifier.setTheme(selectedTheme);
                  _showThemeChangeSnackBar(context, selectedTheme);
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Now Showing',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            FutureBuilder<List<Movie>>(
              future: nowShowingMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading movies'));
                }

                final movies = snapshot.data ?? [];

                return CarouselSlider.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index, movieIndex) {
                    final movie = movies[index];
                    return GestureDetector(
                      onTap: () => context.go('/details/${movie.id}'),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: CachedMovieImage(
                              imagePath: movie.backdropPath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    aspectRatio: 1.4,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text('Popular Movies',
                style: Theme.of(context).textTheme.titleLarge),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 200,
              child: FutureBuilder(
                future: popularMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading movies'));
                  }
                  final movies = snapshot.data ?? [];
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () => context.go('/details/${movie.id}'),
                        child: Container(
                          width: 150.0,
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16.0)),
                            child: CachedMovieImage(
                              imagePath: movie.backdropPath,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Text('Upcoming Movies',
                style: Theme.of(context).textTheme.titleLarge),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 200,
              child: FutureBuilder(
                future: upcomingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading movies'));
                  }
                  final movies = snapshot.data ?? [];
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () => context.go('/details/${movie.id}'),
                        child: Container(
                          width: 150.0,
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16.0)),
                            child: CachedMovieImage(
                              imagePath: movie.backdropPath,
                              height:
                                  200, // Increased height since we removed the text
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<ThemeModeOption> _buildThemeMenuItem(
    BuildContext context,
    ThemeModeOption option,
    String label,
    ThemeNotifier themeNotifier,
  ) {
    final isSelected = themeNotifier.selectedOption == option;

    return PopupMenuItem<ThemeModeOption>(
      value: option,
      child: Row(
        children: [
          Icon(
            option.icon,
            color: isSelected ? Colors.amber : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.amber : null,
              fontWeight: isSelected ? FontWeight.bold : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeChangeSnackBar(
      BuildContext context, ThemeModeOption selectedTheme) {
    String themeName = selectedTheme.name;
    themeName = themeName[0].toUpperCase() + themeName.substring(1);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              selectedTheme.icon,
              color: isDark ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 12),
            Text(
              'Theme switched to $themeName',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        backgroundColor: isDark ? Colors.grey[850] : Colors.grey[200],
        duration: const Duration(seconds: 3), // Increased from 2 to 3 seconds
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 6.0, // Added elevation for more prominence
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
