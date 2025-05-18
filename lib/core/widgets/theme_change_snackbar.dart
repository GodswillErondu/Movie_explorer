import 'package:flutter/material.dart';
import 'package:movie_explorer_app/core/theme_provider.dart';

class ThemeChangeSnackBar {
  static void show(
      BuildContext context,
      ThemeModeOption selectedTheme,
      ) {
    final themeName = _capitalizeFirstLetter(selectedTheme.name);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      _buildSnackBar(context, selectedTheme, themeName, isDark, theme),
    );
  }

  static SnackBar _buildSnackBar(
      BuildContext context,
      ThemeModeOption selectedTheme,
      String themeName,
      bool isDark,
      ThemeData theme,
      ) {
    return SnackBar(
      content: Row(
        children: [
          Icon(
            selectedTheme.icon,
            color: isDark ? Colors.white : Colors.black87,
          ),
          const SizedBox(width: 12),
          Text(
            'Theme switched to $themeName',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
      backgroundColor: isDark ? Colors.grey[850] : Colors.grey[200],
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 6.0,
      action: SnackBarAction(
        label: 'DISMISS',
        textColor: theme.colorScheme.primary,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );
  }

  static String _capitalizeFirstLetter(String input) {
    return input[0].toUpperCase() + input.substring(1);
  }
}