import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonRewardList extends StatelessWidget {
  const SkeletonRewardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 100.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 32.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 32.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        SizedBox(height: 16.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 204.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 16.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 204.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ],
    );
  }
}
