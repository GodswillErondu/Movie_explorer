import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_explorer_app/models/movie.dart';

class CacheService {
  static const String nowShowingBoxName = 'nowShowingMovies';
  static const String popularBoxName = 'popularMovies';
  static const String upcomingBoxName = 'upcomingMovies';
  static const String timestampBoxName = 'timestamps';

  static const Duration cacheValidity = Duration(hours: 12);

  late Box<Movie> _nowShowingBox;
  late Box<Movie> _popularBox;
  late Box<Movie> _upcomingBox;
  late Box<int> _timestampBox;

  static Future<CacheService> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MovieAdapter());

    final service = CacheService();
    await service._openBoxes();
    return service;
  }

  Future<void> _openBoxes() async {
    _nowShowingBox = await Hive.openBox<Movie>(nowShowingBoxName);
    _popularBox = await Hive.openBox<Movie>(popularBoxName);
    _upcomingBox = await Hive.openBox<Movie>(upcomingBoxName);
    _timestampBox = await Hive.openBox<int>(timestampBoxName);
  }
  Future<void> dispose() async {
    await _nowShowingBox.close();
    await _popularBox.close();
    await _upcomingBox.close();
    await _timestampBox.close();
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

  Future<void> clearCache() async {
    await _nowShowingBox.clear();
    await _popularBox.clear();
    await _upcomingBox.clear();
    await _timestampBox.clear();
  }

  bool isCacheValid(String boxName) {
    final timestamp = _timestampBox.get(boxName);
    if (timestamp == null) return false;

    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    return age <= cacheValidity.inMilliseconds;
  }
}
