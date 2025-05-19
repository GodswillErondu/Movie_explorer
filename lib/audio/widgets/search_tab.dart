import 'package:flutter/material.dart';
import 'package:movie_explorer_app/audio/models/song.dart';
import 'package:movie_explorer_app/audio/providers/audio_player_provider.dart';
import 'package:movie_explorer_app/audio/screens/audio_screen.dart';
import 'package:movie_explorer_app/audio/services/audio_service.dart';
import 'package:movie_explorer_app/audio/widgets/song_list_tile.dart';
import 'package:movie_explorer_app/draw/screens/drawing_recognition_screen.dart';
import 'package:provider/provider.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();




    return Consumer<AudioPlayerProvider>(
      builder: (context, audioPlayerProvider, child) {
        _searchController.text = audioPlayerProvider.searchQuery;
        _searchController.selection = TextSelection.fromPosition(TextPosition(offset: _searchController.text.length),);
        return Column(
          children: [
            SearchBar(
              controller: _searchController,
              onChanged: audioPlayerProvider.performSearch,
              onClear: () {
                _searchController.clear();
               audioPlayerProvider.clearSearch();
              },
            ),
            Expanded(
              child: audioPlayerProvider.isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : audioPlayerProvider.searchResults.isEmpty && _searchController.text.isNotEmpty
                  ? const Center(child: Text('No results found'))
                  : audioPlayerProvider.searchResults.isEmpty
                  ? const Center(child: Text('Search for music'))
                  : ListView.builder(
                itemCount: audioPlayerProvider.searchResults.length,
                itemBuilder: (context, index) {
                  final song = audioPlayerProvider.searchResults[index];
                  return SongListTile(
                    song: song,
                    onTap: () {
                      audioPlayerProvider.setPlaylist(
                          audioPlayerProvider.searchResults,
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


  void _openDrawRecognition(BuildContext context) async {
    final audioPlayerProvider =
    Provider.of<AudioPlayerProvider>(context, listen: false);
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const DrawingRecognitionScreen(),
      ),
    );

    if (result != null && result.isNotEmpty && result != 'No text recognized') {
     controller.text = result;
     audioPlayerProvider.performSearch(result);
    }
  }

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
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.text.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  onPressed: onClear,
                ),
              IconButton(
                icon: Icon(
                  Icons.draw,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                onPressed: () => _openDrawRecognition(context),
              ),
            ],
          ),
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