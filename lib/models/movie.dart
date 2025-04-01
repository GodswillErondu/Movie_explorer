class Movie {
  final String title;
  final String backdropPath;
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Movie &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          backdropPath == other.backdropPath &&
          overview == other.overview;

  @override
  int get hashCode =>
      title.hashCode ^ backdropPath.hashCode ^ overview.hashCode;
}
