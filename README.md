# Movie Explorer App

A comprehensive Flutter application for discovering and exploring movies with advanced AI-powered features including handwriting recognition, voice commands, and intelligent audio playback.

## Features

### 🎬 Movie Discovery
- Browse now showing, popular, and upcoming movies
- Detailed movie information and metadata
- Smart caching with 12-hour validity for offline browsing
- TMDB API integration for real-time movie data

### 🎨 Digital Ink Recognition
- Draw and write with your finger or stylus
- AI-powered handwriting recognition using Google ML Kit
- Real-time text recognition from drawings
- Undo/redo functionality for drawing operations

### 🎤 Voice Recognition
- Speech-to-text functionality for hands-free interaction
- Voice commands for movie search and navigation
- Permission-based microphone access

### 🎵 Audio Experience
- Integrated audio player with full playback controls
- Song caching and offline playback support
- Background audio processing

### 🎨 Modern UI/UX
- Material Design 3 with custom theming
- Light and dark mode support
- Responsive design for all screen sizes
- Smooth carousel sliders for movie browsing
- Google Fonts integration

### 💾 Smart Caching
- Hive-based local database for offline functionality
- Automatic cache invalidation and refresh
- Separate caching for movies, audio, and user data
- Graceful cache recovery and error handling

## Tech Stack

### Core Framework
- **Flutter 3.24+** - Cross-platform development
- **Dart 3.4.3+** - Programming language

### State Management & Navigation
- **Provider** - Reactive state management
- **GoRouter** - Declarative routing and navigation

### AI & Machine Learning
- **Google ML Kit Digital Ink Recognition** - Handwriting recognition
- **Google ML Kit Text Recognition** - OCR capabilities
- **Speech to Text** - Voice recognition

### Media & Networking
- **HTTP** - API communication
- **Cached Network Image** - Optimized image loading
- **Just Audio** - Advanced audio playback
- **Carousel Slider** - Interactive image carousels

### Storage & Caching
- **Hive & Hive Flutter** - NoSQL local database
- **Shared Preferences** - Simple key-value storage

### Configuration & Utilities
- **Flutter DotEnv** - Environment variable management
- **Permission Handler** - Runtime permission management
- **Google Fonts** - Typography enhancement

## Getting Started

### Prerequisites
- Flutter SDK `>=3.4.3 <4.0.0`
- Android Studio / VS Code with Flutter extensions
- Platform-specific development tools

### Installation

1. **Clone the repository:**
```bash
git clone <repository-url>
cd movie_explorer_app
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Configure environment:**
Create a `.env` file in the root directory:
```env
TMDB_API_KEY=your_tmdb_api_key_here
JAMENDO_CLIENT_ID=your_jamendo_client_id_here
```

4. **Run the application:**
```bash
flutter run
```

## Project Architecture

```
lib/
├── main.dart                           # Application entry point
├── core/                              # Core functionality
│   ├── router_config.dart             # Navigation configuration
│   ├── theme.dart                     # Material Design theming
│   ├── theme_provider.dart            # Theme state management
│   └── cache_service.dart             # Hive caching service
├── movie/                             # Movie features
│   ├── models/movie.dart              # Movie data models
│   ├── providers/movie_provider.dart  # Movie state management
│   └── services/movie_service.dart    # TMDB API integration
├── audio/                             # Audio features
│   ├── models/song.dart               # Audio data models
│   ├── providers/audio_player_provider.dart
│   └── services/audio_service.dart    # Audio playback service
└── draw/                              # Drawing & Recognition
    └── providers/
        ├── drawing_provider.dart      # Drawing canvas management
        └── drawing_recognition_provider.dart # ML Kit integration
```

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android  | ✅ Full | All features supported |
| iOS      | ✅ Full | All features supported |
| Web      | ✅ Partial | Limited ML Kit support |
| Windows  | ✅ Full | Desktop optimized |
| macOS    | ✅ Full | Desktop optimized |
| Linux    | ✅ Full | Desktop optimized |

## Build Commands

### Development
```bash
# Run in debug mode
flutter run

# Run with specific device
flutter run -d chrome  # Web
flutter run -d windows # Windows
```

### Production Builds
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web (with WebAssembly for better performance)
flutter build web --wasm

# Desktop platforms
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## Configuration

### API Setup
1. Get a TMDB API key from [themoviedb.org](https://www.themoviedb.org/settings/api)
2. Get a Jamendo API client ID from [developer.jamendo.com](https://developer.jamendo.com/)
3. Add both to your `.env` file:
```env
TMDB_API_KEY=your_tmdb_api_key_here
JAMENDO_CLIENT_ID=your_jamendo_client_id_here
```

### Permissions
The app requires the following permissions:
- **Microphone** - For speech recognition
- **Internet** - For movie data and images
- **Storage** - For local caching

## Development

### Code Quality
```bash
# Analyze code
flutter analyze

# Run tests
flutter test

# Format code
dart format .
```

### Cache Management
The app uses intelligent caching with:
- 12-hour cache validity for movie data
- Automatic cache cleanup on errors
- Separate boxes for different data types

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [The Movie Database (TMDB)](https://www.themoviedb.org/) for movie data
- [Jamendo](https://www.jamendo.com/) for music streaming API
- [Google ML Kit](https://developers.google.com/ml-kit) for AI capabilities
- [Flutter Team](https://flutter.dev/) for the amazing framework
