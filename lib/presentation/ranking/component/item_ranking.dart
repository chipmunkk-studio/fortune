import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/domain/supabase/entity/ranking_view_item_entity.dart';

class ItemRanking extends StatelessWidget {
  const ItemRanking({
    super.key,
    required this.item,
    required this.index,
  });

  final RankingPagingViewItemEntity item;
  final int index;

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
            imageUrl: item.profile,
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
                        item.nickName,
                        style: FortuneTextStyle.body2Semibold(color: ColorName.white, height: 1.3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.count,
                      style: FortuneTextStyle.caption2Regular(color: ColorName.grey200),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  index.toString(),
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
