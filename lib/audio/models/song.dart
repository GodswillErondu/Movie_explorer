import 'package:hive_flutter/hive_flutter.dart';


class Song {
  final int id;
  final String title;
  final String artist;
  final String albumArt;
  final String audioUrl;
  final int duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.audioUrl,
    required this.duration,
  });

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      albumArt: map['album_art'],
      audioUrl: map['audio_url'],
      duration: map['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album_art': albumArt,
      'audio_url': audioUrl,
      'duration': duration,
    };
  }

  @override
  int get hashCode => Object.hash(id, title, artist, albumArt, audioUrl, duration);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Song && other.hashCode == hashCode;
}