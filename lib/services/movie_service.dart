// services/movie_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_explorer_app/models/movie.dart';

class APIServices {
  static final String _apiKey = dotenv.get('TMDB_API_KEY');

  Future<List<Movie>> getNowShowingMovies() async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/now_playing?api_key=$_apiKey"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((movie) => Movie.fromMap(movie)).toList();
    } else {
      throw Exception('Failed to load now showing movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((movie) => Movie.fromMap(movie)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/upcoming?api_key=$_apiKey"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((movie) => Movie.fromMap(movie)).toList();
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }
}
