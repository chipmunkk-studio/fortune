import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonRewardList extends StatelessWidget {
  const SkeletonRewardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 100,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        const SizedBox(height: 32),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 32,
            width: double.infinity,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        const SizedBox(height: 16),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 204,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        const SizedBox(height: 16),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 204,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ],
    );
  }
}
