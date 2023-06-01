import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class MissionsSkeleton extends StatelessWidget {
  const MissionsSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            const SkeletonAvatar(
              style: SkeletonAvatarStyle(
                shape: BoxShape.rectangle,
                width: 74,
                height: 74,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 12),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 36.h,
                    width: 128.w,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                const SizedBox(height: 8),
                SkeletonLine(
                  style: SkeletonLineStyle(
                    height: 44.h,
                    width: 188.w,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 68.h,
              width: double.infinity,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 224.h,
              width: double.infinity,
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 140.h,
              width: double.infinity,
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
      ],
    );
  }
}
