import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/core/widgets/painter/squircle_painter.dart';
import 'package:fortune/domain/entity/mission_marker_entity.dart';
import 'package:fortune/presentation-v2/main/fortune_main_ext.dart';

class ItemMarkerLayout extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool shouldDim;
  final int obtainedCount;
  final int requiredCount;

  const ItemMarkerLayout({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.shouldDim,
    required this.obtainedCount,
    required this.requiredCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 148.h,
            minHeight: 120.h,
            maxWidth: 100.h,
            minWidth: 100.h,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: Opacity(
                  opacity: shouldDim ? 0.3 : 1, // 50% 투명도
                  child: CustomPaint(
                    painter: SquirclePainter(color: ColorName.grey800),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: buildFortuneImage(
                        url: imageUrl,
                        width: 68,
                        height: 68,
                        imageShape: ImageShape.none,
                      ),
                    ),
                  ),
                ),
              ),
              if (shouldDim)
                Positioned(
                  right: -8,
                  top: -8,
                  child: Assets.icons.icCollectComplete.svg(),
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Opacity(
                  opacity: shouldDim ? 0.3 : 1,
                  child: Align(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: ColorName.grey800,
                        border: Border.all(
                          color: ColorName.grey900,
                          width: 2,
                        ),
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "$obtainedCount",
                              style: FortuneTextStyle.caption3Semibold(color: ColorName.primary),
                            ),
                            TextSpan(
                              text: "/$requiredCount",
                              style: FortuneTextStyle.caption3Semibold(color: ColorName.grey500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Opacity(
          opacity: shouldDim ? 0.3 : 1,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: FortuneTextStyle.body3Regular(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
