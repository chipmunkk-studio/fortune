import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_exchangeable_marker_entity.dart';

class NeedFortuneArea extends StatelessWidget {
  const NeedFortuneArea(this.haveMarkers, {super.key});

  final List<RewardExchangeableMarkerEntity> haveMarkers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: haveMarkers.length,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              color: ColorName.deActiveDark.withOpacity(0.4),
            ),
            padding: EdgeInsets.only(left: 8, top: 7.h, bottom: 7.h, right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                haveMarkers[index].grade.icon.svg(width: 20, height: 20),
                const SizedBox(width: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "${haveMarkers[index].userHaveCount}",
                        style: FortuneTextStyle.body2SemiBold(
                          fontColor: ColorName.primary,
                        ),
                      ),
                      TextSpan(
                        text: "/${haveMarkers[index].count}",
                        style: FortuneTextStyle.body2SemiBold(
                          fontColor: ColorName.activeDark,
                        ),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
