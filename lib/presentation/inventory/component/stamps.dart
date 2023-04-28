import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_widget.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_painter.dart';

class Stamps extends StatelessWidget {
  const Stamps({
    super.key,
    required this.top,
    required this.center,
    required this.bottom,
    required this.onStampClick,
  });

  final List<int> top;
  final List<int> center;
  final List<int> bottom;
  final Function0 onStampClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _StampIcon(
              isHidden: false,
              icon: Assets.icons.icFortuneCookie.svg(fit: BoxFit.none),
              onStampClick: onStampClick,
            ),
            SizedBox(width: 16.w),
            _StampIcon(
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
            _StampIcon(
              isHidden: true,
              icon: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
            SizedBox(width: 16.w),
            _StampIcon(
              isHidden: true,
              icon: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
            SizedBox(width: 16.w),
            _StampIcon(
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
            _StampIcon(
              isHidden: true,
              icon: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
            SizedBox(width: 16.w),
            _StampIcon(
              isHidden: true,
              icon: Assets.images.ivDefaultProfile.svg(fit: BoxFit.none),
            ),
          ],
        ),
      ],
    );
  }
}

class _StampIcon extends StatelessWidget {
  const _StampIcon({
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
          : ScaleWidget(
              onTapUp: onStampClick,
              child: CustomPaint(
                painter: SquirclePainter(),
                child: icon,
              ),
            ),
    );
  }
}
