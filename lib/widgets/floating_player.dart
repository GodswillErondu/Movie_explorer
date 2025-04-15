import 'package:flutter/material.dart';
import 'package:movie_explorer_app/models/song.dart';
import 'package:movie_explorer_app/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FloatingPlayer extends StatelessWidget {
  const FloatingPlayer({Key? key}) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerProvider>(
      builder: (context, audioPlayerProvider, child) {
        if (!audioPlayerProvider.isPlayerVisible ||
            audioPlayerProvider.currentSong == null) {
          return const SizedBox.shrink();
        }

        final song = audioPlayerProvider.currentSong!;
        final isPlaying = audioPlayerProvider.isPlaying;
        final position = audioPlayerProvider.position;
        final duration = audioPlayerProvider.duration;

        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Duration display with padding
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                // Slider
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 12),
                    trackHeight: 2,
                  ),
                  child: Slider(
                    value: duration.inSeconds > 0
                        ? position.inSeconds.toDouble()
                        : 0.0,
                    min: 0,
                    max: duration.inSeconds > 0
                        ? duration.inSeconds.toDouble()
                        : 1.0,
                    onChanged: (value) {
                      final seekPosition = Duration(seconds: value.toInt());
                      audioPlayerProvider.seek(seekPosition);
                    },
                  )
                ),
                // Player controls
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      ClipRRect(
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              song.artist,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: audioPlayerProvider.playPrevious,
                      ),
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          if (isPlaying) {
                            audioPlayerProvider.pause();
                          } else {
                            audioPlayerProvider.play();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: audioPlayerProvider.playNext,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: audioPlayerProvider.hidePlayer,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
