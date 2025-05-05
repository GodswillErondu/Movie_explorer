import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_explorer_app/models/movie.dart';
import 'package:movie_explorer_app/screens/movie_details_screen.dart';
import 'package:movie_explorer_app/services/movie_service.dart';
import 'package:movie_explorer_app/providers/theme_provider.dart';
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

  // Add counters for each section
  int nowShowingCount = 10;
  int popularCount = 10;
  int upcomingCount = 10;

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
          Consumer<ThemeProvider>(
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
      body: ListView(
        children: [
          _buildMovieSection('Now Showing', nowShowingMovies, nowShowingCount,
              () => setState(() => nowShowingCount += 10)),
          _buildMovieSection('Popular', popularMovies, popularCount,
              () => setState(() => popularCount += 10)),
          _buildMovieSection('Upcoming', upcomingMovies, upcomingCount,
              () => setState(() => upcomingCount += 10)),
        ],
      ),
    );
  }

  Widget _buildMovieSection(String title, Future<List<Movie>> movies,
      int itemCount, VoidCallback onLoadMore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        FutureBuilder<List<Movie>>(
          future: movies,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading movies'));
            }

            final moviesList = snapshot.data ?? [];
            final displayedMovies = moviesList.take(itemCount).toList();
            final hasMore = moviesList.length > itemCount;

            return Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: displayedMovies.length,
                  itemBuilder: (context, index) {
                    final movie = displayedMovies[index];
                    return GestureDetector(
                      onTap: () => context.go('/details/${movie.id}'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: CachedMovieImage(
                            imagePath: movie.backdropPath,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (hasMore)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: onLoadMore,
                      child: const Text('Load More'),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  PopupMenuItem<ThemeModeOption> _buildThemeMenuItem(
    BuildContext context,
    ThemeModeOption option,
    String label,
    ThemeProvider themeNotifier,
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
