import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class MissionDetailSkeleton extends StatelessWidget {
  const MissionDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 75,
              randomLength: true,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          const SizedBox(height: 20),
          SkeletonLine(
            style: SkeletonLineStyle(
              height: 75,
              randomLength: true,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ],
      ),
    );
  }
}
