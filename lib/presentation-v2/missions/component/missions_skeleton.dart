import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class MissionsSkeleton extends StatelessWidget {
  const MissionsSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Column(
        children: [
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 156,
              width: double.infinity,
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
          const SizedBox(height: 20),
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 156,
              width: double.infinity,
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ],
      ),
    );
  }
}