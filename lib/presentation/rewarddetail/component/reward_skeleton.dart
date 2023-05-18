import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class RewardSkeleton extends StatelessWidget {
  const RewardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: SizedBox.square(
            dimension: 280.w,
            child: const SkeletonAvatar(
              style: SkeletonAvatarStyle(
                shape: BoxShape.circle,
                width: 84,
                height: 84,
              ),
            ),
          ),
        ),
        SizedBox(height: 36.h),
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 80.h,
              width: 256.w,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 21.h),
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: SkeletonLine(
            style: SkeletonLineStyle(
              height: 72.h,
              width: 128.w,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ],
    );
  }
}
