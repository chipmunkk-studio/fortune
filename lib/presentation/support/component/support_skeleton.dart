import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class SupportSkeleton extends StatelessWidget {
  const SupportSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 100,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        const SizedBox(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 100,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        const SizedBox(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 100,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        const SizedBox(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 100,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ],
    );
  }
}
