import 'package:flutter/material.dart';
import 'package:movie_explorer_app/movie/models/movie.dart';
import 'package:movie_explorer_app/movie/services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService;

  // Movie lists
  List<Movie> _nowShowingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _upcomingMovies = [];

  // Loading states
  bool _isLoadingNowShowing = false;
  bool _isLoadingPopular = false;
  bool _isLoadingUpcoming = false;

  // Error states
  String? _nowShowingError;
  String? _popularError;
  String? _upcomingError;

  // Display counts
  int _nowShowingCount = 10;
  int _popularCount = 10;
  int _upcomingCount = 10;

  // Track if data has been loaded at least once
  bool _hasLoadedNowShowing = false;
  bool _hasLoadedPopular = false;
  bool _hasLoadedUpcoming = false;

  MovieProvider(this._movieService);

  // Getters
  List<Movie> get nowShowingMovies => _hasLoadedNowShowing
      ? _nowShowingMovies.take(_nowShowingCount).toList()
      : [];

  List<Movie> get popularMovies => _hasLoadedPopular
      ? _popularMovies.take(_popularCount).toList()
      : [];

  List<Movie> get upcomingMovies => _hasLoadedUpcoming
      ? _upcomingMovies.take(_upcomingCount).toList()
      : [];

  bool get isLoadingNowShowing => _isLoadingNowShowing;
  bool get isLoadingPopular => _isLoadingPopular;
  bool get isLoadingUpcoming => _isLoadingUpcoming;

  String? get nowShowingError => _nowShowingError;
  String? get popularError => _popularError;
  String? get upcomingError => _upcomingError;

  bool get hasMoreNowShowing => _nowShowingMovies.length > _nowShowingCount;
  bool get hasMorePopular => _popularMovies.length > _popularCount;
  bool get hasMoreUpcoming => _upcomingMovies.length > _upcomingCount;

  // Initial data loading
  Future<void> loadInitialData() async {
    await Future.wait([
      if (!_hasLoadedNowShowing) loadNowShowingMovies(),
      if (!_hasLoadedPopular) loadPopularMovies(),
      if (!_hasLoadedUpcoming) loadUpcomingMovies(),
    ]);
  }

  // Individual loading methods
  Future<void> loadNowShowingMovies() async {
    if (_isLoadingNowShowing) return;

    _isLoadingNowShowing = true;
    _nowShowingError = null;
    notifyListeners();

    try {
      _nowShowingMovies = await _movieService.getNowShowingMovies();
      _hasLoadedNowShowing = true;
      _nowShowingError = null;
    } catch (e) {
      _nowShowingError = 'Failed to load now showing movies';
      debugPrint('Error loading now showing movies: $e');
    } finally {
      _isLoadingNowShowing = false;
      notifyListeners();
    }
  }

  Future<void> loadPopularMovies() async {
    if (_isLoadingPopular) return;

    _isLoadingPopular = true;
    _popularError = null;
    notifyListeners();

    try {
      _popularMovies = await _movieService.getPopularMovies();
      _hasLoadedPopular = true;
      _popularError = null;
    } catch (e) {
      _popularError = 'Failed to load popular movies';
      debugPrint('Error loading popular movies: $e');
    } finally {
      _isLoadingPopular = false;
      notifyListeners();
    }
  }

  Future<void> loadUpcomingMovies() async {
    if (_isLoadingUpcoming) return;

    _isLoadingUpcoming = true;
    _upcomingError = null;
    notifyListeners();

    try {
      _upcomingMovies = await _movieService.getUpcomingMovies();
      _hasLoadedUpcoming = true;
      _upcomingError = null;
    } catch (e) {
      _upcomingError = 'Failed to load upcoming movies';
      debugPrint('Error loading upcoming movies: $e');
    } finally {
      _isLoadingUpcoming = false;
      notifyListeners();
    }
  }

  // Load more functions
  Future<void> loadMoreNowShowing() async {
    if (!hasMoreNowShowing) return;
    _nowShowingCount += 10;
    notifyListeners();
  }

  Future<void> loadMorePopular() async {
    if (!hasMorePopular) return;
    _popularCount += 10;
    notifyListeners();
  }

  Future<void> loadMoreUpcoming() async {
    if (!hasMoreUpcoming) return;
    _upcomingCount += 10;
    notifyListeners();
  }

  // Refresh functions
  Future<void> refreshNowShowing() async {
    _nowShowingCount = 10;
    _nowShowingMovies = [];
    _hasLoadedNowShowing = false;
    await loadNowShowingMovies();
  }

  Future<void> refreshPopular() async {
    _popularCount = 10;
    _popularMovies = [];
    _hasLoadedPopular = false;
    await loadPopularMovies();
  }

  Future<void> refreshUpcoming() async {
    _upcomingCount = 10;
    _upcomingMovies = [];
    _hasLoadedUpcoming = false;
    await loadUpcomingMovies();
  }

  Future<void> refreshAll() async {
    await Future.wait([
      refreshNowShowing(),
      refreshPopular(),
      refreshUpcoming(),
    ]);
  }
}