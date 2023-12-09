import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_view_entity.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MissionRelayCard extends StatelessWidget {
  const MissionRelayCard(this.item, {super.key});

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
            color: ColorName.grey700,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.mission.title,
                      style: FortuneTextStyle.subTitle1Bold(),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.mission.content,
                        style: FortuneTextStyle.body2Semibold(
                          color: ColorName.grey200,
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
                            color: ColorName.primary.withOpacity(0.3),
                          ),
                          child: Text(
                            "선착순",
                            style: FortuneTextStyle.caption1SemiBold(
                              color: ColorName.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${item.userHaveCount}(보유한 갯수)",
                                style: FortuneTextStyle.body3Regular(color: Colors.white),
                              ),
                              TextSpan(
                                text: "/${item.requiredTotalCount}",
                                style: FortuneTextStyle.body2Semibold(color: ColorName.grey400),
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
              FortuneCachedNetworkImage(
                width: 84,
                height: 84,
                imageShape: ImageShape.circle,
                imageUrl: item.mission.image,
                placeholder: Container(),
                errorWidget: Container(
                  decoration: BoxDecoration(
                    color: ColorName.grey700,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorName.grey700, // 테두리 색을 빨간색으로 설정
                      width: 1.0, // 원하는 테두리 두께
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Assets.images.ivDefaultProfile.svg(),
                  ),
                ),
                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ColorName.grey600,
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
              color: ColorName.grey700,
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
                    percent: item.satisfiedCount / item.totalConditionSize > 1
                        ? 1
                        : item.satisfiedCount / item.totalConditionSize,
                    padding: const EdgeInsets.all(0),
                    barRadius: Radius.circular(16.r),
                    backgroundColor: ColorName.grey400.withOpacity(0.3),
                    progressColor: ColorName.primary,
                  ),
                ),
                const SizedBox(width: 16),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${item.satisfiedCount}(요구 갯수)",
                        style: FortuneTextStyle.body3Regular(color: ColorName.primary),
                      ),
                      TextSpan(
                        text: "/${item.totalConditionSize}",
                        style: FortuneTextStyle.body3Regular(color: ColorName.grey400),
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
