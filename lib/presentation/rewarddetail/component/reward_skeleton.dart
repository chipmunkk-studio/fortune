import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class RewardSkeleton extends StatelessWidget {
  const RewardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.center,
          child: SizedBox.square(
            dimension: 280,
            child: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                shape: BoxShape.circle,
                width: 84,
                height: 84,
              ),
            ),
          ),
        ),
        const SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 80,
              width: 256,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        const SizedBox(height: 21),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 72,
              width: 128,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ],
    );
  }
}
