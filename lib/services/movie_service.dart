import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_explorer_app/models/movie.dart';

const apiKey = '387786b91dd7abadb22950d40d582f5c';

class APIServices {
  final nowShowingApi =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey";

  Future<List<Movie>> getNowShowing() async {
    Uri url = Uri.parse(nowShowingApi);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
