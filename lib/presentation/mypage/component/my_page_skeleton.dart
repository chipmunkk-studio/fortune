import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class MyPageSkeleton extends StatelessWidget {
  const MyPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SkeletonAvatar(
              style: SkeletonAvatarStyle(
                shape: BoxShape.circle,
                width: 84,
                height: 84,
              ),
            ),
            SizedBox(width: 12.w),
            Flexible(
              child: Column(
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 24.h,
                      width: 128.w,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  SizedBox(height: 7.h),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 24.h,
                      width: 178.w,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 84.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 31.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 44.h,
            width: 324.w,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 12.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 44.h,
            width: 256.w,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 12.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 44.h,
            width: 128.w,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 12.h),
        SkeletonLine(
          style: SkeletonLineStyle(
            height: 44.h,
            width: 312.w,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ],
    );
  }
}
