import 'package:flutter/material.dart';
import 'package:movie_explorer_app/core/theme_provider.dart';
import 'package:movie_explorer_app/movie/providers/movie_provider.dart';
import 'package:movie_explorer_app/movie/widgets/movie_section.dart';
import 'package:movie_explorer_app/core/widgets/theme_change_snackbar.dart';
import 'package:provider/provider.dart';

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      movieProvider.loadInitialData();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Explorer',
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          Consumer<ThemeProvider>(
            builder: (context, themeNotifier, child) {
              return PopupMenuButton<ThemeModeOption>(
                icon: Icon(
                  themeNotifier.currentIcon,
                  color: theme.appBarTheme.actionsIconTheme?.color,
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
                  ThemeChangeSnackBar.show(context, selectedTheme);

                },
              );
            },
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          return RefreshIndicator(
            onRefresh: movieProvider.refreshAll,
            child: ListView(
              children: [
                MovieSection(
                  title: 'Now Showing',
                  movies: movieProvider.nowShowingMovies,
                  isLoading: movieProvider.isLoadingNowShowing,
                  error: movieProvider.nowShowingError,
                  hasMore: movieProvider.hasMoreNowShowing,
                  onLoadMore: movieProvider.loadMoreNowShowing,
                ),
                MovieSection(
                  title: 'Popular',
                  movies: movieProvider.popularMovies,
                  isLoading: movieProvider.isLoadingPopular,
                  error: movieProvider.popularError,
                  hasMore: movieProvider.hasMorePopular,
                  onLoadMore: movieProvider.loadMorePopular,
                ),
                MovieSection(
                  title: 'Upcoming',
                  movies: movieProvider.upcomingMovies,
                  isLoading: movieProvider.isLoadingUpcoming,
                  error: movieProvider.upcomingError,
                  hasMore: movieProvider.hasMoreUpcoming,
                  onLoadMore: movieProvider.loadMoreUpcoming,
                ),
              ],
            ),
          );
        },
      ),
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
    BuildContext context,
    ThemeModeOption selectedTheme,
  )

  {
    String themeName = selectedTheme.name;
    themeName = themeName[0].toUpperCase() + themeName.substring(1);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 6.0,
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: theme.colorScheme.primary,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
