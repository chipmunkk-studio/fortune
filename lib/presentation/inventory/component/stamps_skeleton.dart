import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_painter.dart';

class MarkerStampsSkeleton extends StatelessWidget {
  const MarkerStampsSkeleton({
    super.key,
    required this.top,
    required this.center,
    required this.bottom,
  });

  final List<int> top;
  final List<int> center;
  final List<int> bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _MarkerStampIconSkeleton(
              isHidden: true,
              icon: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
            SizedBox(width: 16.w),
            _MarkerStampIconSkeleton(
              isHidden: true,
              icon: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _MarkerStampIconSkeleton(
              isHidden: true,
              icon: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
            SizedBox(width: 16.w),
            _MarkerStampIconSkeleton(
              isHidden: true,
              icon: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
            SizedBox(width: 16.w),
            _MarkerStampIconSkeleton(
              isHidden: true,
              icon: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _MarkerStampIconSkeleton(
              isHidden: true,
              icon: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
            SizedBox(width: 16.w),
            _MarkerStampIconSkeleton(
              isHidden: true,
              icon: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
          ],
        ),
      ],
    );
  }
}

class _MarkerStampIconSkeleton extends StatelessWidget {
  const _MarkerStampIconSkeleton({
    Key? key,
    required this.isHidden,
    required this.icon,
    this.onStampClick,
  }) : super(key: key);

  final bool isHidden;
  final SvgPicture icon;
  final Function0? onStampClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 92,
      child: isHidden
          ? CustomPaint(
              painter: SquirclePainter(),
              child: Assets.icons.icLock.svg(
                fit: BoxFit.none,
              ),
            )
          : Bounceable(
              onTap: onStampClick,
              child: CustomPaint(
                painter: SquirclePainter(),
                child: icon,
              ),
            ),
    );
  }
}
