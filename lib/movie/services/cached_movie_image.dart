import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedMovieImage extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CachedMovieImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[800],
        child: const Icon(
          Icons.movie,
          size: 50,
          color: Colors.white54,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: 'https://image.tmdb.org/t/p/w500$imagePath',
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        color: Colors.grey[800],
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[800],
        child: const Icon(
          Icons.error_outline,
          size: 50,
          color: Colors.white54,
        ),
      ),
    );
  }
}
