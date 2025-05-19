import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


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




