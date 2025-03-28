import 'package:flutter/material.dart';

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(
          'Movie Explorer App',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Card(
                   color: colorScheme.surface,
                    child: Column(
                      children: [
                          Text(
                            'Points',
                            style: theme.textTheme.headlineMedium!.copyWith(color: colorScheme.onPrimaryContainer),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                   color: colorScheme.surface,
                    child: Column(
                      children: [
                          Text(
                            'Points',
                            style: theme.textTheme.headlineMedium!.copyWith(color: colorScheme.onPrimaryContainer),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
