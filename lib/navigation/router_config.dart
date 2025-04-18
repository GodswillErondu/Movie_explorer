import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_explorer_app/screens/audio_screen.dart';
import 'package:movie_explorer_app/screens/movie_screen.dart';
import 'package:movie_explorer_app/screens/movie_details_screen.dart';
import 'package:movie_explorer_app/screens/audio_player_screen.dart';
import 'package:movie_explorer_app/screens/drawing_screen.dart';
import 'package:movie_explorer_app/widgets/scaffold_with_navigation_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final routerConfig = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavigationBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const MovieScreen(),
              routes: [
                GoRoute(
                  path: 'details/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final movieId = state.pathParameters['id']!;
                    return MovieDetailsScreen(movieId: movieId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            StatefulShellRoute.indexedStack(
              builder: (context, state, navigationShell) {
                return AudioScreen(navigationShell: navigationShell);
              },
              branches: [
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/audio/browse',
                      builder: (context, state) => const BrowseTab(),
                      routes: [
                        GoRoute(
                          path: 'player',
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) =>
                              const AudioPlayerScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/audio/search',
                      builder: (context, state) => const SearchTab(),
                      routes: [
                        GoRoute(
                          path: 'player',
                          parentNavigatorKey: _rootNavigatorKey,
                          builder: (context, state) =>
                              const AudioPlayerScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/drawing',
              builder: (context, state) => const DrawingScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
