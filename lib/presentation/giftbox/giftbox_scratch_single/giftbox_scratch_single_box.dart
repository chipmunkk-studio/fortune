import 'package:flutter/material.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:scratcher/scratcher.dart';

class GiftboxScratchSingleBox extends StatefulWidget {
  const GiftboxScratchSingleBox({
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
  State<GiftboxScratchSingleBox> createState() => _GiftboxScratchSingleBoxState();
}

class _GiftboxScratchSingleBoxState extends State<GiftboxScratchSingleBox> {
  bool isScratched = false;
  double opacity = 0.5;

  @override
  Widget build(BuildContext context) {
    var icon = AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 750),
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: FortuneCachedNetworkImage(
          imageUrl: widget.itemImageUrl,
          imageShape: ImageShape.squircle,
          fit: BoxFit.contain,
          width: 200,
          height: 200,
        ),
      ),
    );
    return Scratcher(
      accuracy: ScratchAccuracy.high,
      image: widget.coverImage,
      color: Colors.transparent,
      brushSize: 48,
      threshold: 50,
      onThreshold: () {
        widget.onScratch?.call();
        setState(() {
          opacity = 1;
          isScratched = true;
        });
      },
      child: Container(
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
