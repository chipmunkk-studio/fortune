import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            color: ColorName.grey900,
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
                            color: ColorName.grey700,
                          ),
                          child: Text(
                            "선착순",
                            style: FortuneTextStyle.caption1SemiBold(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${item.relayMarker.hitCount}",
                                style: FortuneTextStyle.body3Light(color: Colors.white),
                              ),
                              TextSpan(
                                text: "/${item.requiredTotalCount} ${item.isRelayMissionCleared}",
                                style: FortuneTextStyle.body2Semibold(color: ColorName.grey700),
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
                  child: FortuneCachedNetworkImage(
                    imageUrl: item.mission.missionReward.rewardImage,
                    placeholder: Container(),
                    errorWidget: const Icon(Icons.error_outline),
                    fit: BoxFit.fill,
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
                color: ColorName.grey700,
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
              color: ColorName.grey900,
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
                    percent: item.relayMarker.hitCount / item.requiredTotalCount > 1
                        ? 1
                        : item.relayMarker.hitCount / item.requiredTotalCount,
                    padding: const EdgeInsets.all(0),
                    barRadius: Radius.circular(16.r),
                    backgroundColor: ColorName.grey700.withOpacity(0.3),
                    progressColor: ColorName.primary,
                  ),
                ),
                const SizedBox(width: 16),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${item.relayMarker.hitCount}",
                        style: FortuneTextStyle.body3Light(color: ColorName.primary),
                      ),
                      TextSpan(
                        text: "/${item.requiredTotalCount}",
                        style: FortuneTextStyle.body3Light(color: ColorName.grey700),
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
