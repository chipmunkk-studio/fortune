import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fortune/core/fortune_ext.dart';
import 'package:fortune/core/gen/colors.gen.dart';

enum ImageShape {
  none, // 기본 형태 (클리핑 안함)
  squircle, // 스쿼클 형태
  circle, // 원형
}

class FortuneCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget placeholder;
  final Widget errorWidget;

  final double? width;
  final double? height;
  final ImageShape imageShape;

  static const _cacheKey = 'fortune_marker';

  static CacheManager cacheManager = CacheManager(
    Config(
      _cacheKey,
      stalePeriod: const Duration(days: 100),
    ),
  );

  const FortuneCachedNetworkImage({
    super.key,
    this.width,
    this.height,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholder = const CircularProgressIndicator(),
    this.imageShape = ImageShape.none,
    Widget? errorWidget,
  }) : errorWidget = errorWidget ?? const Icon(Icons.error_outline_sharp, color: ColorName.grey400);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      cacheManager: cacheManager,
      fit: fit,
      fadeInDuration: const Duration(seconds: 1),
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => errorWidget,
    );

    switch (imageShape) {
      case ImageShape.squircle:
        return ClipPath(
          clipper: SquircleClipper(),
          child: imageWidget,
        );
      case ImageShape.circle:
        return ClipOval(child: imageWidget); // 원형 클리핑
      default:
        return imageWidget;
    }
  }
}

class SquircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    return Path()
      ..moveTo(0, height * 0.5000000)
      ..cubicTo(0, height * 0.1250000, width * 0.1250000, 0, width * 0.5000000, 0)
      ..cubicTo(width * 0.8750000, 0, width, height * 0.1250000, width, height * 0.5000000)
      ..cubicTo(width, height * 0.8750000, width * 0.8750000, height, width * 0.5000000, height)
      ..cubicTo(width * 0.1250000, height, 0, height * 0.8750000, 0, height * 0.5000000)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
