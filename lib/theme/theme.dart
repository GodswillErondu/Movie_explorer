import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: ThemeConstants.primaryColor,
      secondary: ThemeConstants.secondaryColor,
      surface: ThemeConstants.lightSurfaceColor,
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeConstants.primaryColor,
      foregroundColor: ThemeConstants.lightTextColor,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    // Card theme
    cardTheme: CardTheme(
      color: ThemeConstants.lightSurfaceColor,
      elevation: ThemeConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
      ),
    ),

    // PopupMenu theme
    popupMenuTheme: PopupMenuThemeData(
      color: ThemeConstants.lightSurfaceColor,
      elevation: ThemeConstants.modalElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
      ),
      textStyle: const TextStyle(
        color: ThemeConstants.lightTextColor,
        fontSize: 16,
      ),
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: ThemeConstants.lightTextColor,
      size: 24,
    ),

    // Text theme
    textTheme: TextTheme(
      displayLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: ThemeConstants.lightTextColor,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: ThemeConstants.lightTextColor,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        color: ThemeConstants.lightTextColor,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        color: ThemeConstants.lightSecondaryTextColor,
      ),
    ),

    // Snackbar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ThemeConstants.darkSurfaceColor,
      contentTextStyle: const TextStyle(color: ThemeConstants.darkTextColor),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: ThemeConstants.primaryColor,
      secondary: ThemeConstants.secondaryColor,
      surface: ThemeConstants.darkSurfaceColor,
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeConstants.darkSurfaceColor,
      foregroundColor: ThemeConstants.darkTextColor,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    // Card theme
    cardTheme: CardTheme(
      color: ThemeConstants.darkSurfaceColor,
      elevation: ThemeConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
      ),
    ),

    // PopupMenu theme
    popupMenuTheme: PopupMenuThemeData(
      color: ThemeConstants.darkSurfaceColor,
      elevation: ThemeConstants.modalElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
      ),
      textStyle: const TextStyle(
        color: ThemeConstants.darkTextColor,
        fontSize: 16,
      ),
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: ThemeConstants.darkTextColor,
      size: 24,
    ),

    // Text theme
    textTheme: TextTheme(
      displayLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: ThemeConstants.darkTextColor,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: ThemeConstants.darkTextColor,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        color: ThemeConstants.darkTextColor,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        color: ThemeConstants.darkSecondaryTextColor,
      ),
    ),

    // Snackbar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ThemeConstants.lightSurfaceColor,
      contentTextStyle: const TextStyle(color: ThemeConstants.lightTextColor),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
      ),
    ),
  );
}
