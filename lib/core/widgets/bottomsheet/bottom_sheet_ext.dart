import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';

extension FortuneBottomSheet on BuildContext {
  /// 기본 바텀시트.
  ///
  /// isShowTopBar 상단 센터 바.
  Future<T?> showBottomSheet<T>({
    required Widget Function(BuildContext) content,
    bool isShowCloseButton = true,
    bool isDismissible = true,
    bool isShowTopBar = false,
  }) async {
    return await showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: ColorName.grey800,
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      builder: (context) => SafeArea(
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              if (isShowTopBar) ...[
                const SizedBox(height: 25),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: ColorName.grey700,
                      ),
                    ),
                    const Spacer()
                  ],
                ),
                SizedBox(height: isShowCloseButton ? 0 : 25),
              ],
              if (isShowCloseButton) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Bounceable(
                            onTap: () => Navigator.pop(context),
                            child: Assets.icons.icXcircleFill24.svg(width: 28, height: 28),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              content(context),
            ],
          ),
        ),
      ),
    );
  }

  Future<T?> showFullBottomSheet<T>({
    required Widget Function(BuildContext) scrollContent,
    required Widget Function(BuildContext) topContent,
    bool isShowCloseButton = true,
    bool isDismissible = true,
    bool isShowTopBar = false,
    double heightFactor = 1.0,
  }) async {
    final statusBarHeight = MediaQuery.of(this).padding.top;
    final screenHeight = MediaQuery.of(this).size.height;
    final adjustedHeightFactor = (heightFactor - (statusBarHeight / screenHeight)).clamp(0.1, 1.0);

    return await showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: ColorName.grey800,
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      builder: (context) => SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: adjustedHeightFactor,
          maxChildSize: adjustedHeightFactor,
          minChildSize: 0.1,
          builder: (context, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Top Bar Widget
                if (isShowTopBar)
                  Column(
                    children: [
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          const Spacer(),
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              color: ColorName.grey700,
                            ),
                          ),
                          const Spacer()
                        ],
                      ),
                      SizedBox(height: isShowCloseButton ? 0 : 25),
                    ],
                  ),

                // Close Button Widget
                if (isShowCloseButton)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Bounceable(
                              onTap: () => Navigator.pop(context),
                              child: Assets.icons.icXcircleFill24.svg(width: 28, height: 28),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                topContent(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: scrollContent(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
