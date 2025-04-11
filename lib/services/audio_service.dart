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
      : _apiBaseUrl = dotenv.get('JAMENDO_BASE_URL'),
        _clientId = dotenv.get('JAMENDO_CLIENT_ID');

  Future<List<Song>> getSongs() async {
    try {
      final cached = _cacheService.getCachedSongs();
      if (cached != null) return cached;

      final response = await http
          .get(
            Uri.parse(
              "$_apiBaseUrl/tracks/?client_id=$_clientId&format=json&limit=20&include=musicinfo&boost=popularity",
            ),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['headers']['status'] == 'success' && data['results'] != null) {
          final List<dynamic> tracksData = data['results'];
          final songs =
              tracksData.map((track) => _mapTrackToSong(track)).toList();
          await _cacheService.cacheSongs(songs);
          return songs;
        } else {
          throw Exception('Failed to parse song data from API');
        }
      } else {
        throw Exception('Failed to load songs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching songs: $e');
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
      final response = await http
          .get(
            Uri.parse(
              "$_apiBaseUrl/tracks/?client_id=$_clientId&format=json&limit=20&search=$query&include=musicinfo",
            ),
          )
          .timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['headers']['status'] == 'success' && data['results'] != null) {
          final List<dynamic> tracksData = data['results'];
          return tracksData.map((track) => _mapTrackToSong(track)).toList();
        } else {
          throw Exception('Failed to parse search results from API');
        }
      } else {
        throw Exception('Failed to search songs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching songs: $e');
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
        albumArt: "https://via.placeholder.com/300",
        audioUrl:
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        duration: 240,
      ),
      Song(
        id: 2,
        title: "Acoustic Sunrise",
        artist: "Guitar Masters",
        albumArt: "https://via.placeholder.com/300",
        audioUrl:
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
        duration: 185,
      ),
      Song(
        id: 3,
        title: "Midnight Jazz",
        artist: "Smooth Saxophones",
        albumArt: "https://via.placeholder.com/300",
        audioUrl:
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
        duration: 320,
      ),
      Song(
        id: 4,
        title: "Urban Beat",
        artist: "City Sounds",
        albumArt: "https://via.placeholder.com/300",
        audioUrl:
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3",
        duration: 198,
      ),
      Song(
        id: 5,
        title: "Peaceful Piano",
        artist: "Classical Notes",
        albumArt: "https://via.placeholder.com/300",
        audioUrl:
            "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3",
        duration: 274,
      ),
    ];
  }
}
