import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_explorer_app/models/movie.dart';


class APIServices {

  static final String _apiKey = dotenv.get('TMDB_API_KEY');


  final nowShowingMovieApiUrl =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=$_apiKey";
  final popularMovieApiUrl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey";
  final upcomingMovieApiUrl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$_apiKey";

  Future<List<Movie>> getNowShowingMovies() async {
    final response = await http.get(Uri.parse(nowShowingMovieApiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load');
    }
  }
  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(nowShowingMovieApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load');
    }
  }
  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(nowShowingMovieApiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load');
    }
  }

}