import 'package:hive/hive.dart';


class Movie {
  final String title;
  final String backdropPath;
  final String overview;
  final int id;

  Movie({
    required this.title,
    required this.backdropPath,
    required this.overview,
    required this.id,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    if (id == null) {
      throw FormatException('Movie data must contain an ID');
    }

    return Movie(
      id: id is String ? int.parse(id) : id as int,
      title: map['title'] ?? 'No Title',
      backdropPath: map['backdrop_path'] ?? '',
      overview: map['overview'] ?? 'No description available',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'backdrop_path': backdropPath,
      'overview': overview,
    };
  }

  @override
  int get hashCode => Object.hash(id, title, backdropPath, overview);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie &&
          other.id == id &&
          other.title == title &&
          other.backdropPath == backdropPath &&
          other.overview == overview;
}
