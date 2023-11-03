import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fortune/core/fortune_ext.dart';
import 'package:fortune/core/gen/colors.gen.dart';

class FortuneCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget placeholder;
  final Widget errorWidget;

  final double? width;
  final double? height;

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
    Widget? errorWidget,
  }) : errorWidget = errorWidget ?? const Icon(Icons.error_outline_sharp, color: ColorName.grey400);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: kReleaseMode ? imageUrl : getSampleNetworkImageUrl(width: 92, height: 92),
      width: width,
      height: height,
      cacheManager: cacheManager,
      fit: fit,
      fadeInDuration: const Duration(seconds: 1),
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => errorWidget,
    );
  }
}
