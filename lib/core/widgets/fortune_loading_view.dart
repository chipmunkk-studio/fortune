import 'package:dotlottie_loader/dotlottie_loader.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';

class FortuneLoadingView extends StatelessWidget {
  final double? width;
  final double? height;

  const FortuneLoadingView({
    super.key,
    this.width = 136,
    this.height = 136,
  });

  @override
  Widget build(BuildContext context) {
    return DotLottieLoader.fromAsset(
      Assets.lottie.loading,
      frameBuilder: (ctx, dotlottie) {
        return dotlottie != null
            ? Lottie.memory(
                dotlottie.animations.values.single,
                width: width,
                height: height,
              )
            : Container();
      },
      errorBuilder: (ctx, e, s) => Container(),
    );
  }
}
