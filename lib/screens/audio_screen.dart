import 'package:flutter/material.dart';
import 'package:movie_explorer_app/models/song.dart';
import 'package:movie_explorer_app/providers/audio_player_provider.dart';
import 'package:movie_explorer_app/services/audio_service.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> with TickerProviderStateMixin {
  late Future<List<Song>> _songsFuture;
  late AudioService _audioService;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<Song> _searchResults = [];
  bool _isSearching = false;

  final List<String> _genres = [
    'All', 'Rock', 'Electronic', 'Jazz', 'Classical', 'Hip-Hop', 'Pop'
  ];
  String _selectedGenre = 'All';

  @override
  void initState() {
    super.initState();
    _audioService = Provider.of<AudioService>(context, listen: false);
    _songsFuture = _audioService.getSongs();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

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
      final results = await _audioService.searchSongs(query);
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

  Future<List<Song>> _loadSongsByGenre(String genre) {
    if (genre == 'All') {
      return _audioService.getSongs();
    } else {
      return _audioService.getSongsByGenre(genre);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        backgroundColor: Colors.amber,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Browse'),
            Tab(text: 'Search'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Browse Tab
          Column(
            children: [
              // Genre filter chips
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _genres.map((genre) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        selected: _selectedGenre == genre,
                        label: Text(genre),
                        onSelected: (selected) {
                          setState(() {
                            _selectedGenre = genre;
                            _songsFuture = _loadSongsByGenre(genre);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Songs list
              Expanded(
                child: FutureBuilder<List<Song>>(
                  future: _songsFuture,
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
                              onPressed: () {
                                setState(() {
                                  _songsFuture = _loadSongsByGenre(_selectedGenre);
                                });
                              },
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
                            final audioPlayerProvider =
                            Provider.of<AudioPlayerProvider>(context, listen: false);
                            audioPlayerProvider.setPlaylist(songs, initialIndex: index);
                            audioPlayerProvider.play();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          // Search Tab
          Column(
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
                        final audioPlayerProvider =
                        Provider.of<AudioPlayerProvider>(
                            context, listen: false);
                        audioPlayerProvider.setPlaylist(
                            _searchResults,
                            initialIndex: index);
                        audioPlayerProvider.play();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
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