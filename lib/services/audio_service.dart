import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_explorer_app/models/song.dart';
import 'package:movie_explorer_app/services/cache_service.dart';
import '../core/constants/app_constants.dart';

class AudioService {
  final CacheService _cacheService;
  final String _apiBaseUrl;
  final String _clientId;

  AudioService(this._cacheService)
      : _apiBaseUrl = dotenv.get('JAMENDO_BASE_URL',
            fallback: 'https://api.jamendo.com/v3.0'),
        _clientId = dotenv.get('JAMENDO_CLIENT_ID');

  Future<List<Song>> getSongs() async {
    try {
      final cached = _cacheService.getCachedSongs();
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }

      final url = Uri.parse(
          "$_apiBaseUrl/tracks/?client_id=$_clientId&format=json&limit=20&include=musicinfo&boost=popularity_total");

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['headers']['status'] == 'failed') {
          return _getMockSongs();
        }

        final List<dynamic> tracksData = data['results'] as List<dynamic>;

        if (tracksData.isEmpty) {
          return _getMockSongs();
        }

        final songs =
            tracksData.map((track) => _mapTrackToSong(track)).toList();
        await _cacheService.cacheSongs(songs);
        return songs;
      } else {
        return _getMockSongs();
      }
    } catch (e, stackTrace) {
      return _getMockSongs();
    }
  }

  // Map Jamendo track data to our Song model
  Song _mapTrackToSong(Map<String, dynamic> track) {
    return Song(
      id: int.parse(track['id'].toString()),
      title: track['name'] ?? 'Unknown Title',
      artist: track['artist_name'] ?? 'Unknown Artist',
      albumArt: track['album_image'] ?? 'https://via.placeholder.com/300',
      audioUrl: track['audio'] ?? '',
      duration: int.parse((track['duration'] ?? '0').toString()),
    );
  }

  // Search for songs by query
  Future<List<Song>> searchSongs(String query) async {
    try {
      final url = Uri.parse(
          "$_apiBaseUrl/tracks/?client_id=$_clientId&format=json&limit=20&search=$query&include=musicinfo");

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> tracksData =
            (data['results'] as List<dynamic>?) ?? [];

        return tracksData
            .map((track) => Song(
                  id: int.parse(track['id']?.toString() ?? '0'),
                  title: track['name'] as String? ?? 'Unknown Title',
                  artist: track['artist_name'] as String? ?? 'Unknown Artist',
                  albumArt: track['album_image'] as String? ?? '',
                  audioUrl: track['audio'] as String? ?? '',
                  duration: int.parse(track['duration']?.toString() ?? '0'),
                ))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Get songs by genre
  Future<List<Song>> getSongsByGenre(String genre) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              "$_apiBaseUrl/tracks/?client_id=$_clientId&format=json&limit=20&tags=$genre&include=musicinfo",
            ),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['headers']['status'] == 'success' && data['results'] != null) {
          final List<dynamic> tracksData = data['results'];
          return tracksData.map((track) => _mapTrackToSong(track)).toList();
        } else {
          throw Exception('Failed to parse genre results from API');
        }
      } else {
        throw Exception('Failed to get songs by genre: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting songs by genre: $e');
      return [];
    }
  }

  // Mock data for development/demo purposes
  List<Song> _getMockSongs() {
    return [
      Song(
        id: 1,
        title: "Summer Nights",
        artist: "Electronic Dreams",
        albumArt:
            "https://picsum.photos/300", // Changed from via.placeholder.com
        audioUrl:
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        duration: 240,
      ),
      Song(
        id: 2,
        title: "Acoustic Sunrise",
        artist: "Guitar Masters",
        albumArt:
            "https://picsum.photos/300", // Changed from via.placeholder.com
        audioUrl:
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        duration: 185,
      ),
      Song(
        id: 3,
        title: "Midnight Jazz",
        artist: "Smooth Saxophones",
        albumArt:
            "https://picsum.photos/300", // Changed from via.placeholder.com
        audioUrl:
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
        duration: 210,
      ),
    ];
  }
}
