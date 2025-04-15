import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_explorer_app/providers/audio_player_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

const double kMiniPlayerHeight = 60.0;

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerProvider>(
      builder: (context, audioProvider, child) {
        if (!audioProvider.isPlayerVisible ||
            audioProvider.currentSong == null) {
          return const SizedBox.shrink();
        }

        final song = audioProvider.currentSong!;
        final isPlaying = audioProvider.isPlaying;

        return GestureDetector(
          onTap: () {
            // Use GoRouter to navigate to audio screen
            context.go('/audio/browse');
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: kMiniPlayerHeight,
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
              children: [
                // Progress bar
                LinearProgressIndicator(
                  value: audioProvider.progress,
                  minHeight: 2,
                  backgroundColor: Colors.transparent,
                ),
                // Player controls
                Expanded(
                  child: Row(
                    children: [
                      // Album art
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            imageUrl: song.albumArt,
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const ColoredBox(
                              color: Colors.grey,
                              child: Icon(Icons.music_note),
                            ),
                          ),
                        ),
                      ),
                      // Song info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              song.title,
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              song.artist,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Playback controls
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            onPressed: audioProvider.playPrevious,
                            iconSize: 24,
                          ),
                          IconButton(
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow),
                            onPressed: () {
                              if (isPlaying) {
                                audioProvider.pause();
                              } else {
                                audioProvider.play();
                              }
                            },
                            iconSize: 32,
                          ),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            onPressed: audioProvider.playNext,
                            iconSize: 24,
                          ),
                        ],
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
