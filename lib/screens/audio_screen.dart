import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_explorer_app/models/song.dart';
import 'package:movie_explorer_app/providers/audio_player_provider.dart';
import 'package:movie_explorer_app/services/audio_service.dart';
import 'package:provider/provider.dart';

class AudioScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AudioScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          NavigationBar(
            selectedIndex: _getCurrentIndex(context),
            onDestinationSelected: (index) {
              // Replace direct navigation with navigationShell.goBranch
              navigationShell.goBranch(
                index,
                initialLocation: index == 0,
              );
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.browse_gallery),
                label: 'Browse',
              ),
              NavigationDestination(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
            ],
          ),
          Expanded(
            child: navigationShell,
          ),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    return navigationShell.currentIndex;
  }
}

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

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Song> _searchResults = [];
  bool _isSearching = false;

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await Provider.of<AudioService>(context, listen: false)
          .searchSongs(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for songs or artists',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchResults = [];
                    _isSearching = false;
                  });
                },
              ),
            ),
            onSubmitted: _performSearch,
            textInputAction: TextInputAction.search,
          ),
        ),
        Expanded(
          child: _isSearching
              ? const Center(child: CircularProgressIndicator())
              : _searchResults.isEmpty && _searchController.text.isNotEmpty
                  ? const Center(child: Text('No results found'))
                  : _searchResults.isEmpty
                      ? const Center(child: Text('Search for music'))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final song = _searchResults[index];
                            return SongListTile(
                              song: song,
                              onTap: () {
                                audioPlayerProvider.setPlaylist(_searchResults,
                                    initialIndex: index);
                                audioPlayerProvider.play();
                              },
                            );
                          },
                        ),
        ),
      ],
    );
  }
}

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
