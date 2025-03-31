import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_explorer_app/models/movie.dart';
import 'package:movie_explorer_app/screens/movie_details_screen.dart';
import 'package:movie_explorer_app/services/movie_service.dart';
import 'package:movie_explorer_app/theme/theme_notifier.dart';
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

  @override
  void initState() {
    nowShowingMovies = APIServices().getNowShowingMovies();
    popularMovies = APIServices().getNowShowingMovies();
    upcomingMovies = APIServices().getNowShowingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Explorer'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
              if (themeNotifier.themeMode == ThemeMode.light) {
                themeNotifier.setTheme(ThemeMode.dark);
              } else {
                themeNotifier.setTheme(ThemeMode.light);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text('Now Showing'),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(movie: movie),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 1.4,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                );
              },
            ),


            const Text('Popular Movies'),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 200,
              child: FutureBuilder(
                future: popularMovies, builder: (context, snapshot) {
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(movie: movie),
                          ),
                        );
                      },
                      child: Container(
                        width: 150.0,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );              },
              ),
            ),

            const Text('Upcoming Movies'),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 200,
              child: FutureBuilder(
                future: upcomingMovies, builder: (context, snapshot) {
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(movie: movie),
                          ),
                        );
                      },
                      child: Container(
                        width: 150.0,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                );              },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
