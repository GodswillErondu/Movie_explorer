import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String backdropPath;

  @HiveField(2)
  final String overview;

  Movie({
    required this.title,
    required this.backdropPath,
    required this.overview,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'] ?? 'No Title',
      backdropPath: map['backdrop_path'] ?? '',
      overview: map['overview'] ?? 'No description available',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'backdrop_path': backdropPath,
      'overview': overview,
    };
  }

  @override
  int get hashCode => Object.hash(title, backdropPath, overview);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Movie && other.hashCode == hashCode;
}
