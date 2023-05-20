import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_painter.dart';
import 'package:foresh_flutter/domain/entities/inventory_entity.dart';
import 'package:foresh_flutter/domain/entities/marker/marker_grade_entity.dart';

class MarkerStamps extends StatelessWidget {
  const MarkerStamps({
    super.key,
    required this.onStampClick,
    required this.stamps,
  });

  final List<InventoryMarkerEntity> stamps;
  final Function0 onStampClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _MarkerStampIcon(
              isOpen: stamps[0].open,
              icon: getMarkerGradeIconInfo(stamps[0].grade.grade).icon.svg(fit: BoxFit.none),
              onStampClick: stamps[0].open ? onStampClick : null,
              count: stamps[0].count.toString(),
            ),
            SizedBox(width: 16.w),
            _MarkerStampIcon(
              isOpen: stamps[1].open,
              icon: getMarkerGradeIconInfo(stamps[1].grade.grade).icon.svg(fit: BoxFit.none),
              onStampClick: stamps[1].open ? onStampClick : null,
              count: stamps[1].count.toString(),
            ),
          ],
        ),
        SizedBox(height: 16.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _MarkerStampIcon(
              isOpen: stamps[5].open,
              icon: getMarkerGradeIconInfo(stamps[5].grade.grade).icon.svg(fit: BoxFit.none),
              onStampClick: stamps[5].open ? onStampClick : null,
              count: stamps[5].count.toString(),
            ),
            SizedBox(width: 16.w),
            _MarkerStampIcon(
              isOpen: stamps[6].open,
              icon: getMarkerGradeIconInfo(stamps[6].grade.grade).icon.svg(fit: BoxFit.none),
              onStampClick: stamps[6].open ? onStampClick : null,
              count: stamps[6].count.toString(),
            ),
            SizedBox(width: 16.w),
            _MarkerStampIcon(
              isOpen: stamps[2].open,
              icon: getMarkerGradeIconInfo(stamps[2].grade.grade).icon.svg(fit: BoxFit.none),
              onStampClick: stamps[2].open ? onStampClick : null,
              count: stamps[2].count.toString(),
            ),
          ],
        ),
        SizedBox(height: 16.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _MarkerStampIcon(
              isOpen: stamps[4].open,
              icon: getMarkerGradeIconInfo(stamps[4].grade.grade).icon.svg(fit: BoxFit.none),
              onStampClick: stamps[4].open ? onStampClick : null,
              count: stamps[4].count.toString(),
            ),
            SizedBox(width: 16.w),
            _MarkerStampIcon(
              isOpen: stamps[3].open,
              icon: getMarkerGradeIconInfo(stamps[3].grade.grade).icon.svg(fit: BoxFit.none),
              onStampClick: stamps[3].open ? onStampClick : null,
              count: stamps[3].count.toString(),
            ),
          ],
        ),
      ],
    );
  }
}

class _MarkerStampIcon extends StatelessWidget {
  const _MarkerStampIcon({
    Key? key,
    required this.count,
    required this.isOpen,
    required this.icon,
    this.onStampClick,
  }) : super(key: key);

  final bool isOpen;
  final SvgPicture icon;
  final Function0? onStampClick;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onStampClick,
      child: Stack(
        children: [
          SizedBox.square(
            dimension: 92.h,
            child: !isOpen
                ? CustomPaint(
                    painter: SquirclePainter(color: ColorName.deActiveDark.withOpacity(0.4)),
                    child: Assets.icons.icLock.svg(
                      fit: BoxFit.none,
                    ),
                  )
                : CustomPaint(
                    painter: SquirclePainter(color: ColorName.deActiveDark.withOpacity(0.4)),
                    child: icon,
                  ),
          ),
          isOpen
              ? Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 6.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: ColorName.negative,
                    ),
                    child: Text(count.toString(), style: FortuneTextStyle.caption1SemiBold()),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
