import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_explorer_app/audio/models/song.dart';

class SongListTile extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;

  const SongListTile({
    Key? key,
    required this.song,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          imageUrl: song.albumArt,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 50,
            height: 50,
            color: Colors.grey,
            child: const Icon(Icons.music_note),
          ),
          errorWidget: (context, url, error) => Container(
            width: 50,
            height: 50,
            color: Colors.grey,
            child: const Icon(Icons.music_note),
          ),
        ),
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: Text(_formatDuration(song.duration)),
      onTap: onTap,
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = duration.inSeconds - minutes * 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
