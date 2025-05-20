import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_explorer_app/audio/models/song.dart';
import 'package:movie_explorer_app/audio/providers/audio_player_provider.dart';
import 'package:movie_explorer_app/audio/screens/audio_screen.dart';
import 'package:movie_explorer_app/audio/services/audio_service.dart';
import 'package:movie_explorer_app/audio/widgets/song_list_tile.dart';
import 'package:provider/provider.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = Provider.of<AudioService>(context, listen: false);
    final audioPlayerProvider =
    Provider.of<AudioPlayerProvider>(context, listen: false);

    return FutureBuilder<List<Song>>(
      future: audioService.getSongs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Error loading songs'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/audio/browse'),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final songs = snapshot.data ?? [];
        if (songs.isEmpty) {
          return const Center(child: Text('No songs available'));
        }

        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return SongListTile(
              song: song,
              onTap: () {
                audioPlayerProvider.setPlaylist(songs, initialIndex: index);
                audioPlayerProvider.play();
              },
            );
          },
        );
      },
    );
  }
}