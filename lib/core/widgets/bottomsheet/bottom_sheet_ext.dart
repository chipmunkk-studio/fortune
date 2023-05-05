import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';

extension FortuneBottomSheet on BuildContext {
  /// 기본 바텀시트.
  ///
  /// isShowTopBar 상단 센터 바.
  showFortuneBottomSheet({
    required Widget Function(BuildContext) content,
    bool isShowCloseButton = true,
    bool isDismissible = true,
    bool isShowTopBar = false,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      context: this,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 48.h),
        child: Wrap(
          children: [
            isShowTopBar
                ? Column(
                    children: [
                      SizedBox(height: 25.h),
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            width: 40.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: ColorName.deActiveDark,
                            ),
                          ),
                          const Spacer()
                        ],
                      ),
                      SizedBox(height: isShowCloseButton ? 0.h : 25.h),
                    ],
                  )
                : Container(),
            isShowCloseButton
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        SizedBox(height: 25.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkResponse(
                              radius: 25,
                              onTap: () => Navigator.pop(context),
                              splashColor: ColorName.backgroundLight,
                              child: Assets.icons.icCancel.svg(width: 24, height: 24),
                            ),
                            SizedBox(width: 25.w),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(),
            content(context),
          ],
        ),
      ),
    );
  }
}
