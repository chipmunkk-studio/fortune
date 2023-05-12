import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/presentation/fortune_ext.dart';
import 'package:transparent_image/transparent_image.dart';

class RewardImage extends StatelessWidget {
  const RewardImage({
    super.key,
    required this.contentImage,
  });

  final String contentImage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox.square(
        dimension: 280.w,
        child: ClipOval(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: contentImage.isEmpty ? transparentImageUrl : contentImage,
          ),
        ),
      ),
    );
  }
}
