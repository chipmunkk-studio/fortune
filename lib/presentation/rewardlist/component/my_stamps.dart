import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_painter.dart';
import 'package:foresh_flutter/domain/entities/marker_grade_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_marker_entity.dart';

class MyStamps extends StatefulWidget {
  final int totalMarkerCount;
  final List<RewardMarkerEntity> markers;

  const MyStamps({
    Key? key,
    required this.totalMarkerCount,
    required this.markers,
  }) : super(key: key);

  @override
  State<MyStamps> createState() => _MyStampsState();
}

class _MyStampsState extends State<MyStamps> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      color: ColorName.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.icons.icInventory.svg(width: 16, height: 16),
                SizedBox(width: 8.w),
                Text(
                  "내가 보유한 포춘",
                  style: FortuneTextStyle.body2Regular(fontColor: ColorName.activeDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text("${widget.totalMarkerCount}개", style: FortuneTextStyle.subTitle2Bold()),
            SizedBox(height: 16.h),
          ],
        ),
        trailing: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: _isExpanded
              ? Assets.icons.icArrowUp.svg(width: 20, height: 20)
              : Assets.icons.icArrowDown.svg(width: 20, height: 20),
        ),
        tilePadding: EdgeInsets.only(
          left: 24.w,
          right: 20.w,
        ),
        onExpansionChanged: (bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        initiallyExpanded: _isExpanded,
        children: [
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            shrinkWrap: true,
            mainAxisSpacing: 12.w,
            crossAxisSpacing: 12.w,
            padding: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 20.h, top: 8.h),
            children: widget.markers
                .map(
                  (e) => Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: SquirclePainter(color: ColorName.deActiveDark.withOpacity(0.4)),
                          child: e.open
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: getMarkerGradeIconInfo(e.grade.grade).icon.svg(
                                        fit: BoxFit.cover,
                                      ),
                                )
                              : Assets.icons.icLock.svg(
                                  fit: BoxFit.none,
                                ),
                        ),
                      ),
                      e.open
                          ? Positioned(
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: ColorName.negative,
                                ),
                                child: Text(e.count.toString(), style: FortuneTextStyle.caption1SemiBold()),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
