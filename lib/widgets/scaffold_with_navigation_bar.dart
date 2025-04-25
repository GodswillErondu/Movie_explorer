import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_explorer_app/widgets/mini_player.dart';
import 'package:provider/provider.dart';
import 'package:movie_explorer_app/providers/audio_player_provider.dart';

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key);

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AudioPlayerProvider>(
        builder: (context, audioProvider, child) {
          // Calculate bottom padding based on player visibility
          final bottomPadding =
              audioProvider.isPlayerVisible ? kMiniPlayerHeight : 0.0;

          return Column(
            children: [
              // Main content with flexible height
              Expanded(
                child: navigationShell,
              ),
              // Mini player that slides in/out
              const MiniPlayer(),
            ],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == 0,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          NavigationDestination(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
          NavigationDestination(
            icon: Icon(Icons.draw),
            label: 'Draw',
          ),
          NavigationDestination(
            icon: Icon(Icons.text_fields),
            label: 'Recognize',
          ),
        ],
      ),
    );
  }
}
