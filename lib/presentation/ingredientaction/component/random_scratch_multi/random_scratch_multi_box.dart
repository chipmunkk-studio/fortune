import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:scratcher/scratcher.dart';

class RandomScratchMultiBox extends StatefulWidget {
  const RandomScratchMultiBox({
    super.key,
    required this.coverImage,
    required this.itemImageUrl,
    this.onScratch,
    this.animation,
  });

  final Image coverImage;
  final String itemImageUrl;
  final VoidCallback? onScratch;
  final Animation<double>? animation;

  @override
  State<RandomScratchMultiBox> createState() => _RandomScratchMultiBoxState();
}

class _RandomScratchMultiBoxState extends State<RandomScratchMultiBox> {
  bool isScratched = false;
  double opacity = 0.5;

  @override
  Widget build(BuildContext context) {
    var icon = AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 750),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FortuneCachedNetworkImage(
          imageUrl: widget.itemImageUrl,
          imageShape: ImageShape.squircle,
          fit: BoxFit.contain,
          width: 96,
          height: 96,
        ),
      ),
    );

    return Scratcher(
      accuracy: ScratchAccuracy.high,
      color: Colors.transparent,
      image: widget.coverImage,
      brushSize: 28,
      threshold: 50,
      onThreshold: () {
        widget.onScratch?.call();
        setState(() {
          opacity = 1;
          isScratched = true;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: widget.animation == null
            ? icon
            : ScaleTransition(
                scale: widget.animation!,
                child: icon,
              ),
      ),
    );
  }
}
