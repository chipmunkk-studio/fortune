import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';

class ItemMyMissionReward extends StatelessWidget {
  const ItemMyMissionReward({
    super.key,
    required this.item,
  });

  final MissionClearUserHistoriesEntity item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FortuneCachedNetworkImage(
            width: 44,
            height: 44,
            imageUrl: item.mission.missionReward.rewardImage,
            placeholder: Container(),
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.mission.title,
                        style: FortuneTextStyle.body2Semibold(color: ColorName.white, height: 1.3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.createdAt,
                      style: FortuneTextStyle.caption2Regular(color: ColorName.grey200),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.mission.missionReward.rewardName,
                  style: FortuneTextStyle.body3Light(color: ColorName.grey100),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
