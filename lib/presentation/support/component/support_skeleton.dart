import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class SupportSkeleton extends StatelessWidget {
  const SupportSkeleton({Key? key}) : super(key: key);

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
        SizedBox(height: 20.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 100.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 20.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 100.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 20.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 100.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 20.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 100.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 20.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 100.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ],
    );
  }
}
