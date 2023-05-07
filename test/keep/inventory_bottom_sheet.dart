import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_widget.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_painter.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';

class InventoryBottomSheet extends StatefulWidget {
  const InventoryBottomSheet({Key? key}) : super(key: key);

  @override
  State<InventoryBottomSheet> createState() => _InventoryBottomSheetState();
}

class _InventoryBottomSheetState extends State<InventoryBottomSheet> with SingleTickerProviderStateMixin {
  final data = {
    "E쿠폰/상품권": [
      "카페/베이커리",
      "편의점",
      "백화점",
      "외식",
    ],
    "상품권/서비스": [
      "상품권/서비스1",
      "상품권/서비스2",
    ],
    "체험권": [
      "체험권1",
      "체험권2",
      "체험권3",
      "체험권4",
      "체험권5",
    ],
    "포춘": [
      "Item 1 (D)",
      "Item 2 (D)",
      "Item 3 (D)",
      "Item 4 (D)",
      "Item 5 (D)",
      "Item 6 (D)",
      "Item 7 (D)",
      "Item 8 (D)",
      "Item 9 (D)",
    ],
    "아이템1": [
      "Item 1 (A)",
      "Item 2 (A)",
      "Item 3 (A)",
      "Item 4 (A)",
    ],
    "아이템2": [
      "Item 1 (B)",
      "Item 2 (B)",
    ],
    "아이템3": [
      "Item 1 (C)",
      "Item 2 (C)",
      "Item 3 (C)",
      "Item 4 (C)",
      "Item 5 (C)",
    ],
    "아이템4": [
      "Item 1 (D)",
      "Item 2 (D)",
      "Item 3 (D)",
      "Item 4 (D)",
      "Item 5 (D)",
      "Item 6 (D)",
      "Item 7 (D)",
      "Item 8 (D)",
      "Item 9 (D)",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return ScrollableListTabScroller(
      tabBuilder: (BuildContext context, int index, bool active) => Padding(
        padding: EdgeInsets.only(left: () {
          if (index == 0) {
            return 20.w;
          } else {
            return 16.w;
          }
        }(), right: () {
          if (index == data.length - 1) {
            return 20.w;
          } else {
            return 0.w;
          }
        }()),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final text = Text(
              data.keys.elementAt(index),
              style: FortuneTextStyle.body1SemiBold(fontColor: !active ? ColorName.deActive : ColorName.active),
            );
            final textSpan = TextSpan(
              text: text.data,
              style: text.style,
            );
            final textPainter = TextPainter(
              text: textSpan,
              textDirection: TextDirection.ltr,
            )..layout();
            return Column(
              children: [
                text,
                SizedBox(height: 4.h),
                active
                    ? Container(
                        width: textPainter.width.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: !active ? ColorName.deActive : ColorName.active,
                        ),
                      )
                    : Container(),
              ],
            );
          },
        ),
      ),
      headerContainerBuilder: (context, child) => child,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) => GridView.count(
        key: GlobalKey(),
        crossAxisCount: 3,
        shrinkWrap: true,
        mainAxisSpacing: 24.h,
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 40.h, bottom: 30.h),
        physics: const NeverScrollableScrollPhysics(),
        children: data.values
            .elementAt(index)
            .asMap()
            .entries
            .map(
              (entry) => Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(16.r),
                    child: ScaleWidget(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomPaint(
                            painter: SquirclePainter(color: ColorName.backgroundLight),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                              child: Assets.icons.icLock.svg(width: 60.w, height: 60.h),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(entry.value, style: FortuneTextStyle.body3Regular())
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
