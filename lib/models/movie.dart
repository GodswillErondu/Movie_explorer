class Movie {
  final String title;
  final String? backdropPath;
  final String overview;

  Movie({
    required this.title,
    this.backdropPath,
    required this.overview,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'] ?? 'No Title',
      backdropPath: map['backdrop_path'],
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
}