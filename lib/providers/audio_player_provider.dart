import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:movie_explorer_app/models/song.dart';

class AudioPlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = 0;
  bool _isPlayerVisible = false;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _progress = 0.0;

  AudioPlayer get audioPlayer => _audioPlayer;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  Song? get currentSong =>
      _playlist.isNotEmpty ? _playlist[_currentIndex] : null;
  bool get isPlayerVisible => _isPlayerVisible;
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Duration get duration => _duration;
  double get progress => _progress;

  AudioPlayerProvider() {
    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      _isPlaying = playerState.playing;
      notifyListeners();
    });

    // Listen to position changes
    _audioPlayer.positionStream.listen((position) {
      _position = position;
      updateProgress(position, _duration);
      notifyListeners();
    });

    // Listen to duration changes
    _audioPlayer.durationStream.listen((duration) {
      _duration = duration ?? Duration.zero;
      updateProgress(_position, _duration);
      notifyListeners();
    });

    // Listen to sequence state for current song changes
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null && index != _currentIndex) {
        _currentIndex = index;
        notifyListeners();
      }
    });
  }

  void setPlaylist(List<Song> songs, {int initialIndex = 0}) async {
    _playlist = songs;
    _currentIndex = initialIndex;

    // Create a list of AudioSources from the songs
    final playlist = ConcatenatingAudioSource(
      children: songs
          .map((song) => AudioSource.uri(Uri.parse(song.audioUrl)))
          .toList(),
    );

    // Set the playlist
    await _audioPlayer.setAudioSource(playlist, initialIndex: initialIndex);
    _isPlayerVisible = true;
    notifyListeners();
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void playNext() {
    if (_currentIndex < _playlist.length - 1) {
      _audioPlayer.seekToNext();
    }
  }

  void playPrevious() {
    if (_currentIndex > 0) {
      _audioPlayer.seekToPrevious();
    } else {
      // If at the beginning, restart the current song
      _audioPlayer.seek(Duration.zero);
    }
  }

  void toggleVisibility() {
    _isPlayerVisible = !_isPlayerVisible;
    notifyListeners();
  }

  void hidePlayer() {
    _isPlayerVisible = false;
    notifyListeners();
  }

  void showPlayer() {
    _isPlayerVisible = true;
    notifyListeners();
  }

  void updateProgress(Duration position, Duration duration) {
    if (duration.inMilliseconds > 0) {
      _progress = position.inMilliseconds / duration.inMilliseconds;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
