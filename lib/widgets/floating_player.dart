import 'package:flutter/material.dart';
import 'package:movie_explorer_app/models/song.dart';
import 'package:movie_explorer_app/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FloatingPlayer extends StatelessWidget {
  const FloatingPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerProvider>(
      builder: (context, audioPlayerProvider, child) {
        if (!audioPlayerProvider.isPlayerVisible || audioPlayerProvider.currentSong == null) {
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
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    trackHeight: 2,
                  ),
                  child: Slider(
                    value: position.inSeconds.toDouble(),
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      audioPlayerProvider.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                      // Song info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              // style: Theme.of(context).textTheme.subtitle1,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              song.artist,
                              // style: Theme.of(context).textTheme.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Controls
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