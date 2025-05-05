import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme_constants.dart';

class ThemeProvider with ChangeNotifier {
  static const String _prefsKey = 'theme_mode';
  late SharedPreferences _prefs;

  ThemeModeOption? _selectedOption;

  late Brightness _currentPlatformBrightness;

  ThemeProvider() {
    _currentPlatformBrightness =
        ui.PlatformDispatcher.instance.platformBrightness;

    ui.PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      final newBrightness = ui.PlatformDispatcher.instance.platformBrightness;
      if (_currentPlatformBrightness != newBrightness) {
        _currentPlatformBrightness = newBrightness;
        if (_selectedOption == null ||
            _selectedOption == ThemeModeOption.system) {
          _applyTheme();
          notifyListeners();
        }
      }
    };

    _loadPreference();
  }

  ThemeModeOption? get selectedOption => _selectedOption;

  IconData get currentIcon {
    return _selectedOption?.icon ?? ThemeModeOption.system.icon;
  }

  ThemeMode get effectiveThemeMode {
    if (_selectedOption == null || _selectedOption == ThemeModeOption.system) {
      return _currentPlatformBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light;
    }
    return _selectedOption!.mode;
  }

  void _applyTheme() {
    final isDark = effectiveThemeMode == ThemeMode.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: isDark
          ? ThemeConstants.darkSurfaceColor
          : ThemeConstants.lightSurfaceColor,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    ));
  }

  Future<void> _loadPreference() async {
    _prefs = await SharedPreferences.getInstance();
    final savedTheme = _prefs.getString(_prefsKey);
    if (savedTheme != null) {
      _selectedOption = ThemeModeOption.fromString(savedTheme);
      _applyTheme();
      notifyListeners();
    } else {
      _applyTheme();
    }
  }

  Future<void> setTheme(ThemeModeOption option) async {
    _selectedOption = option;
    await _prefs.setString(_prefsKey, option.name);
    _applyTheme();
    notifyListeners();
  }

  Future<void> cycleTheme() async {
    const values = ThemeModeOption.values;
    final currentIndex =
        _selectedOption == null ? -1 : values.indexOf(_selectedOption!);
    final nextOption = values[(currentIndex + 1) % values.length];
    await setTheme(nextOption);
  }

  Future<void> clearThemeSelection() async {
    _selectedOption = null;
    await _prefs.remove(_prefsKey);
    _applyTheme();
    notifyListeners();
  }

  @override
  void dispose() {
    ui.PlatformDispatcher.instance.onPlatformBrightnessChanged = null;
    super.dispose();
  }
}

enum ThemeModeOption {
  system(ThemeMode.system, Icons.brightness_auto),
  light(ThemeMode.light, Icons.dark_mode),
  dark(ThemeMode.dark, Icons.light_mode);

  final ThemeMode mode;
  final IconData icon;

  const ThemeModeOption(this.mode, this.icon);

  static ThemeModeOption fromString(String value) {
    return ThemeModeOption.values.firstWhere(
      (option) => option.name == value,
      orElse: () => ThemeModeOption.system,
    );
  }
}
