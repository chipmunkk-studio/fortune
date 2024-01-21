import 'package:flutter/material.dart';
import 'package:fortune/domain/supabase/entity/ranking_view_item_entity.dart';

import 'item_ranking_content.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ItemRankingContent(
        index: index,
        profile: item.profile,
        nickName: item.nickName,
        count: item.count,
        level: item.level,
        grade: item.grade,
      ),
    );
  }
}
