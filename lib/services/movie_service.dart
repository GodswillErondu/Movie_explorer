import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_explorer_app/models/movie.dart';
import 'package:movie_explorer_app/services/cache_service.dart';
import '../core/constants/app_constants.dart';

class MovieService {
  static final String _apiKey = dotenv.get('TMDB_API_KEY');
  final CacheService _cacheService;

  MovieService(this._cacheService);

  Future<Movie?> getMovieById(String id) async {
    try {
      // First check cache
      final cached = await _cacheService.getMovieById(id);
      if (cached != null) return cached;

      // If not in cache, fetch from API
      final response = await http
          .get(
            Uri.parse("${AppConstants.apiBaseUrl}/movie/$id?api_key=$_apiKey"),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final movie = Movie.fromMap(data);
        // Cache the fetched movie
        await _cacheService.cacheMovie(movie);
        return movie;
      } else {
        throw Exception('Failed to load movie with ID: $id');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Movie>> getNowShowingMovies() async {
    try {
      final cached =
          _cacheService.getCachedMovies(CacheService.nowShowingBoxName);
      if (cached != null) return cached;

      final response = await http
          .get(
            Uri.parse(
                "${AppConstants.apiBaseUrl}/movie/now_playing?api_key=$_apiKey"),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        final movies = data.map((movie) => Movie.fromMap(movie)).toList();
        await _cacheService.cacheMovies(CacheService.nowShowingBoxName, movies);
        return movies;
      } else {
        throw Exception('Failed to load now showing movies');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    try {
      final cached = _cacheService.getCachedMovies(CacheService.popularBoxName);
      if (cached != null) return cached;

      final response = await http
          .get(
            Uri.parse(
                "${AppConstants.apiBaseUrl}/movie/popular?api_key=$_apiKey"),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        final movies = data.map((movie) => Movie.fromMap(movie)).toList();
        await _cacheService.cacheMovies(CacheService.popularBoxName, movies);
        return movies;
      } else {
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    try {
      final cached =
          _cacheService.getCachedMovies(CacheService.upcomingBoxName);
      if (cached != null) return cached;

      final response = await http
          .get(
            Uri.parse(
                "${AppConstants.apiBaseUrl}/movie/upcoming?api_key=$_apiKey"),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['results'];
        final movies = data.map((movie) => Movie.fromMap(movie)).toList();
        await _cacheService.cacheMovies(CacheService.upcomingBoxName, movies);
        return movies;
      } else {
        throw Exception('Failed to load upcoming movies');
      }
    } catch (e) {
      rethrow;
    }
  }

  List<Movie> _mapMoviesFromResponse(Map<String, dynamic> response) {
    final List<dynamic> results = response['results'] ?? [];
    return results.map((movieData) {
      final movie = Movie.fromMap(movieData);
      assert(movie.id != 0, 'Movie ID should not be 0');
      return movie;
    }).toList();
  }
}
