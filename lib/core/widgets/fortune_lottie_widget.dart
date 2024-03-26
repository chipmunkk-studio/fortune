import 'dart:io';

import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:lottie/lottie.dart';

class FortuneLottieWidget extends StatelessWidget {
  final String lottieUrl;
  final double? width;
  final double? height;

  const FortuneLottieWidget({
    super.key,
    required this.lottieUrl,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _downloadAndCacheLottie(lottieUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingWidget();
        }
        if (snapshot.hasError) {
          return _errorWidget(snapshot.error);
        }
        if (snapshot.hasData) {
          return _buildLottie(snapshot.data);
        }
        return _emptyWidget();
      },
    );
  }

  Widget _buildLottie(File? lottieFileData) {
    if (lottieFileData == null) return _emptyWidget();

    return DotLottieLoader.fromFile(
      lottieFileData,
      frameBuilder: (ctx, dotlottie) {
        return dotlottie != null
            ? Lottie.memory(
                dotlottie.animations.values.single,
                width: width,
                height: height,
              )
            : _emptyWidget();
      },
      errorBuilder: (ctx, e, s) => _errorWidget(e),
    );
  }

  Widget _loadingWidget() => Container();

  Widget _emptyWidget() => Container();

  Widget _errorWidget(Object? error) => Container();

  Future<File?> _downloadAndCacheLottie(String url) async {
    final cacheManager = FortuneCachedNetworkImage.cacheManager;
    final fileInfo = await cacheManager.getFileFromCache(url);

    if (fileInfo != null) {
      return fileInfo.file;
    } else {
      try {
        final file = await cacheManager.getSingleFile(url);
        return file;
      } catch (e) {
        // 에러 처리
        return null;
      }
    }
  }
}
