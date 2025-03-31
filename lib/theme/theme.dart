import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(surface: Colors.amber.shade400),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.amber, foregroundColor: Colors.grey, ),
    scaffoldBackgroundColor: Colors.white,
    cardTheme: const CardTheme(color: Colors.white70,),
    textTheme: TextTheme(
      displayLarge: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold,),
      titleLarge: GoogleFonts.oswald(
        fontSize: 30,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    )
);

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(surface: Colors.amber),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.amber, foregroundColor: Colors.grey, ),
    scaffoldBackgroundColor: Colors.black12,
    cardTheme: const CardTheme(color: Colors.amber,),

    textTheme: TextTheme(
      displayLarge: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold,),
      titleLarge: GoogleFonts.oswald(
        fontSize: 30,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    )
);
