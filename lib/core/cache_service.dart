import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_explorer_app/movie/models/movie.dart';
import 'package:movie_explorer_app/audio/models/song.dart';

class CacheService {
  static const String nowShowingBoxName = 'nowShowingMovies';
  static const String popularBoxName = 'popularMovies';
  static const String upcomingBoxName = 'upcomingMovies';
  static const String timestampBoxName = 'timestamps';
  static const String moviesBoxName = 'movies';
  static const String songsBoxName = 'songs';
  static const Duration cacheValidity = Duration(hours: 12);

  late Box<Map> _nowShowingBox;
  late Box<Map> _popularBox;
  late Box<Map> _upcomingBox;
  late Box<int> _timestampBox;
  late Box<Map> _songsBox;

  static Future<void> clearAllBoxes() async {
    await Hive.deleteBoxFromDisk(nowShowingBoxName);
    await Hive.deleteBoxFromDisk(popularBoxName);
    await Hive.deleteBoxFromDisk(upcomingBoxName);
    await Hive.deleteBoxFromDisk(timestampBoxName);
    await Hive.deleteBoxFromDisk(moviesBoxName);
    await Hive.deleteBoxFromDisk(songsBoxName);
  }

  static Future<CacheService> initialize() async {
    await Hive.initFlutter();
    try {
      await clearAllBoxes();
    } catch (e) {
    }

    _registerAdapters();

    final service = CacheService();
    await service._openBoxes();
    return service;
  }

  static void _registerAdapters() {
  }

  Future<void> _openBoxes() async {
    try {
      _nowShowingBox = await Hive.openBox<Map>(nowShowingBoxName);
      _popularBox = await Hive.openBox<Map>(popularBoxName);
      _upcomingBox = await Hive.openBox<Map>(upcomingBoxName);
      _timestampBox = await Hive.openBox<int>(timestampBoxName);
      _songsBox = await Hive.openBox<Map>(songsBoxName);
    } catch (e) {
      await clearAllBoxes();
      _nowShowingBox = await Hive.openBox<Map>(nowShowingBoxName);
      _popularBox = await Hive.openBox<Map>(popularBoxName);
      _upcomingBox = await Hive.openBox<Map>(upcomingBoxName);
      _timestampBox = await Hive.openBox<int>(timestampBoxName);
      _songsBox = await Hive.openBox<Map>(songsBoxName);
    }
  }

  Future<void> dispose() async {
    await _nowShowingBox.close();
    await _popularBox.close();
    await _upcomingBox.close();
    await _timestampBox.close();
    await _songsBox.close();
    await Hive.close();
  }

  Future<Movie?> getMovieById(String id) async {
    final box = await Hive.openBox<Map>(moviesBoxName);
    final movieMap = box.get(id);
    return movieMap != null
        ? Movie.fromMap(Map<String, dynamic>.from(movieMap))
        : null;
  }

  Future<void> cacheMovie(Movie movie) async {
    final box = await Hive.openBox<Map>(moviesBoxName);
    await box.put(movie.id.toString(), movie.toMap());
  }

  Future<void> cacheMovies(String boxName, List<Movie> movies) async {
    final box = await Hive.openBox<Map>(boxName);
    final Map<String, Map<String, dynamic>> movieMap = {
      for (var movie in movies) movie.id.toString(): movie.toMap()
    };
    await box.putAll(movieMap);
    await _timestampBox.put(boxName, DateTime.now().millisecondsSinceEpoch);
  }

  List<Movie>? getCachedMovies(String boxName) {
    final timestamp = _timestampBox.get(boxName);
    if (timestamp == null) return null;

    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (age > cacheValidity.inMilliseconds) return null;

    final box = _getBox(boxName);
    return box.values
        .map((map) => Movie.fromMap(Map<String, dynamic>.from(map)))
        .toList();
  }

  Box<Map> _getBox(String boxName) {
    switch (boxName) {
      case nowShowingBoxName:
        return _nowShowingBox;
      case popularBoxName:
        return _popularBox;
      case upcomingBoxName:
        return _upcomingBox;
      default:
        throw ArgumentError('Invalid box name: $boxName');
    }
  }

  Future<void> cacheSongs(List<Song> songs) async {
    await _songsBox.clear();
    final songMaps = songs.map((song) => song.toMap()).toList();
    for (var i = 0; i < songMaps.length; i++) {
      await _songsBox.put(i, songMaps[i]);
    }
    await _timestampBox.put(
        songsBoxName, DateTime.now().millisecondsSinceEpoch);
  }

  List<Song>? getCachedSongs() {
    final timestamp = _timestampBox.get(songsBoxName);
    if (timestamp == null) return null;

    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (age > cacheValidity.inMilliseconds) return null;

    return _songsBox.values
        .map((map) => Song.fromMap(Map<String, dynamic>.from(map)))
        .toList();
  }

  Future<void> clearCache() async {
    await _nowShowingBox.clear();
    await _popularBox.clear();
    await _upcomingBox.clear();
    await _timestampBox.clear();
    await _songsBox.clear();
  }

  bool isCacheValid(String boxName) {
    final timestamp = _timestampBox.get(boxName);
    if (timestamp == null) return false;

    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    return age <= cacheValidity.inMilliseconds;
  }
}
