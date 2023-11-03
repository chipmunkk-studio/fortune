import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/core/widgets/painter/squircle_image_view.dart';

class ProfileImage extends StatelessWidget {
  final Function0 onProfileTap;
  final String profileUrl;

  const ProfileImage({
    super.key,
    required this.onProfileTap,
    required this.profileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onProfileTap,
      child: Stack(
        children: [
          FortuneCachedNetworkImage(
            imageUrl: profileUrl,
            width: 92,
            height: 92,
            placeholder: CustomPaint(child: Assets.images.ivDefaultProfile.svg(fit: BoxFit.cover)),
            imageShape: ImageShape.squircle,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox.square(
              dimension: 24,
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(4),
                  child: Assets.icons.icPencil.svg(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
