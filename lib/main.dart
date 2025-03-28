import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_explorer_app/screens/movie_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    final ColorScheme colorScheme = ColorScheme.fromSeed(
        brightness: MediaQuery.platformBrightnessOf(context),
        seedColor: Colors.amber,);

    return MaterialApp(
      theme: ThemeData(
        colorScheme:colorScheme,
        appBarTheme: AppBarTheme(backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary, ),
        scaffoldBackgroundColor: colorScheme.onPrimary,

        textTheme: TextTheme(
          displayLarge: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold,),
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        )
      ),
      home: MovieScreen(),
    );
  }
}

