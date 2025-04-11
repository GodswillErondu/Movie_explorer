import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_explorer_app/models/movie.dart';
import 'package:movie_explorer_app/models/song.dart';

class CacheService {
  static const String nowShowingBoxName = 'nowShowingMovies';
  static const String popularBoxName = 'popularMovies';
  static const String upcomingBoxName = 'upcomingMovies';
  static const String timestampBoxName = 'timestamps';

  static const String songsBoxName = 'songs';


  static const Duration cacheValidity = Duration(hours: 12);

  late Box<Movie> _nowShowingBox;
  late Box<Movie> _popularBox;
  late Box<Movie> _upcomingBox;
  late Box<int> _timestampBox;

  late Box<Song> _songsBox;


  static Future<CacheService> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MovieAdapter());
    Hive.registerAdapter(SongAdapter());


    final service = CacheService();
    await service._openBoxes();
    return service;
  }

  Future<void> _openBoxes() async {
    _nowShowingBox = await Hive.openBox<Movie>(nowShowingBoxName);
    _popularBox = await Hive.openBox<Movie>(popularBoxName);
    _upcomingBox = await Hive.openBox<Movie>(upcomingBoxName);
    _timestampBox = await Hive.openBox<int>(timestampBoxName);

    _songsBox = await Hive.openBox<Song>(songsBoxName);

  }

  Future<void> dispose() async {
    await _nowShowingBox.close();
    await _popularBox.close();
    await _upcomingBox.close();
    await _timestampBox.close();

    await _songsBox.close();
    await Hive.close();
  }

  Future<void> cacheMovies(String boxName, List<Movie> movies) async {
    final box = _getBox(boxName);
    await box.clear();
    await box.addAll(movies);
    await _timestampBox.put(boxName, DateTime.now().millisecondsSinceEpoch);
  }

  List<Movie>? getCachedMovies(String boxName) {
    final timestamp = _timestampBox.get(boxName);
    if (timestamp == null) return null;

    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (age > cacheValidity.inMilliseconds) return null;

    final box = _getBox(boxName);
    return box.values.toList();
  }

  Box<Movie> _getBox(String boxName) {
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
    await _songsBox.addAll(songs);
    await _timestampBox.put(songsBoxName, DateTime.now().millisecondsSinceEpoch);
  }

  List<Song>? getCachedSongs() {
    final timestamp = _timestampBox.get(songsBoxName);
    if (timestamp == null) return null;

    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (age > cacheValidity.inMilliseconds) return null;

    return _songsBox.values.toList();
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
