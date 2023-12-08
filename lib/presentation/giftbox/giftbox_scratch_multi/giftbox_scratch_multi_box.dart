import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';

class GiftboxScratchMultiBox extends StatefulWidget {
  const GiftboxScratchMultiBox({
    super.key,
    required this.itemImageUrl,
    this.animation,
  });

  final String itemImageUrl;
  final Animation<double>? animation;

  @override
  State<GiftboxScratchMultiBox> createState() => _GiftboxScratchMultiBoxState();
}

class _GiftboxScratchMultiBoxState extends State<GiftboxScratchMultiBox> {
  @override
  Widget build(BuildContext context) {
    var icon = AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 750),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FortuneCachedNetworkImage(
          imageUrl: widget.itemImageUrl,
          imageShape: ImageShape.squircle,
          placeholder: Container(),
          fit: BoxFit.contain,
          width: 96,
          height: 96,
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: widget.animation == null
          ? icon
          : ScaleTransition(
              scale: widget.animation!,
              child: icon,
            ),
    );
  }
}
