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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Music Player',
          style: theme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        centerTitle: true,
        iconTheme: theme.appBarTheme.iconTheme,
        systemOverlayStyle: theme.appBarTheme.systemOverlayStyle,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.navigationBarTheme.backgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1.0,
                ),
              ),
            ),
            child: NavigationBar(
              height: theme.navigationBarTheme.height,
              backgroundColor: Colors.transparent,
              selectedIndex: _getCurrentIndex(context),
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == 0,
                );
              },
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              indicatorColor: theme.colorScheme.primary.withOpacity(0.12),
              destinations: [
                NavigationDestination(
                  icon: Icon(
                    Icons.browse_gallery,
                    color: _getCurrentIndex(context) == 0
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.64),
                  ),
                  label: 'Browse',
                  selectedIcon: Icon(
                    Icons.browse_gallery,
                    color: theme.colorScheme.primary,
                  ),
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.search,
                    color: _getCurrentIndex(context) == 1
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withOpacity(0.64),
                  ),
                  label: 'Search',
                  selectedIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
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
        SearchBar(
          controller: _searchController,
          onChanged: _performSearch,
          onClear: () {
            _searchController.clear();
            setState(() {
              _searchResults = [];
              _isSearching = false;
            });
          },
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

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onSurface.withOpacity(0.12),
            width: 1.0,
          ),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Search music...',
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: isDark
              ? theme.colorScheme.surface.withOpacity(0.06)
              : theme.colorScheme.surface.withOpacity(0.04),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: theme.colorScheme.onSurface.withOpacity(0.12),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: theme.colorScheme.onSurface.withOpacity(0.12),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: theme.colorScheme.primary.withOpacity(0.5),
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
      ),
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
