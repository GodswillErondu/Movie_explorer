import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_explorer_app/movie/models/movie.dart';
import 'package:movie_explorer_app/movie/services/cached_movie_image.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final VoidCallback onLoadMore;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    required this.isLoading,
    required this.error,
    required this.hasMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        if (isLoading && movies.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32.0),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (error != null && movies.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                error ?? 'An error occurred',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            ),
          ),
        if (movies.isNotEmpty)
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
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () => context.go('/details/${movie.id}'),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
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
        if (hasMore && !isLoading)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: onLoadMore,
              child: const Text('Load More'),
            ),
          ),
      ],
    );
  }
}
