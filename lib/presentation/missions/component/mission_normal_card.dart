import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_view_entity.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:transparent_image/transparent_image.dart';

class MissionNormalCard extends StatelessWidget {
  const MissionNormalCard(this.item, {super.key});

  final MissionViewEntity item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 12, top: 24, bottom: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            color: ColorName.backgroundDark,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.mission.bigTitle,
                      style: FortuneTextStyle.subTitle3SemiBold(),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.mission.bigSubtitle,
                        style: FortuneTextStyle.body2Regular(
                          fontColor: ColorName.activeDark,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            color: ColorName.deActiveDark,
                          ),
                          child: Text(
                            "남은 리워드",
                            style: FortuneTextStyle.caption1SemiBold(
                              fontColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${item.mission.remainCount}",
                                style: FortuneTextStyle.body3Regular(fontColor: Colors.white),
                              ),
                              TextSpan(
                                text: "/${item.mission.rewardCount}",
                                style: FortuneTextStyle.body3Regular(fontColor: ColorName.deActive),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox.square(
                dimension: 84,
                child: ClipOval(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: item.mission.rewardImage,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ColorName.deActiveDark,
                width: 0.5,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
              color: ColorName.backgroundDark,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: LinearPercentIndicator(
                    animation: true,
                    lineHeight: 12,
                    animationDuration: 2000,
                    percent: item.userHaveCount / item.requiredTotalCount > 1
                        ? 1
                        : item.userHaveCount / item.requiredTotalCount,
                    padding: const EdgeInsets.all(0),
                    barRadius: Radius.circular(16.r),
                    backgroundColor: ColorName.deActive.withOpacity(0.3),
                    progressColor: ColorName.primary,
                  ),
                ),
                const SizedBox(width: 16),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${item.userHaveCount}",
                        style: FortuneTextStyle.body3Bold(fontColor: ColorName.primary),
                      ),
                      TextSpan(
                        text: "/${item.requiredTotalCount}",
                        style: FortuneTextStyle.body3Regular(fontColor: ColorName.deActive),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
