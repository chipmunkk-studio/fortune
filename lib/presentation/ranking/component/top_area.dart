import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/domain/supabase/entity/ranking_view_item_entity.dart';

class TopArea extends StatelessWidget {
  const TopArea({
    super.key,
    required this.items,
  });

  final List<RankingPagingViewItemEntity> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: _Top3ViewItem(
                item: items[1],
                ranking: 2,
              ),
            ),
            SizedBox(width: 20.h),
            _Top3ViewItem(
              item: items[0],
              ranking: 1,
            ),
            SizedBox(width: 20.h),
            Flexible(
              child: _Top3ViewItem(
                item: items[2],
                ranking: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Top3ViewItem extends StatelessWidget {
  const _Top3ViewItem({
    required this.item,
    required this.ranking,
  });

  final RankingPagingViewItemEntity item;
  final int ranking;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle, // 원 모양을 지정
                border: Border.all(
                  color: _getRankingBorderColor(ranking), // 테두리 색상
                  width: 3.0, // 테두리 두께
                ),
              ),
              child: ClipOval(
                child: FortuneCachedNetworkImage(
                  imageUrl: item.profile,
                  placeholder: Container(),
                  errorWidget: Padding(
                    padding: EdgeInsets.all(ranking == 1 ? 24.0.h : 16.h),
                    child: Assets.images.ivDefaultProfile.svg(width: 24.h, height: 24.h),
                  ),
                  width: _getRankingImageSize(ranking),
                  height: _getRankingImageSize(ranking),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: -10,
              right: 0,
              left: 0,
              child: _getRankingIcon(ranking),
            ),
          ],
        ),
        SizedBox(height: 28.h),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 110.h),
          child: Text(
            item.nickName + item.nickName + item.nickName + item.nickName,
            overflow: TextOverflow.ellipsis,
            style: FortuneTextStyle.caption1SemiBold(),
          ),
        ),
        SizedBox(height: 8.h),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 100.h),
          child: Text(
            item.count,
            style: FortuneTextStyle.caption1SemiBold(color: ColorName.primary),
          ),
        ),
      ],
    );
  }

  _getRankingBorderColor(int ranking) {
    switch (ranking) {
      case 1:
        return const Color(0xFFF6B75B);
      case 2:
        return const Color(0xFFC8C9CA);
      case 3:
        return const Color(0xFFCC9C7B);
      default:
        return const Color(0xFFF6B75B);
    }
  }

  double _getRankingImageSize(int ranking) {
    switch (ranking) {
      case 1:
        return 104.h;
      default:
        return 72.h;
    }
  }

  _getRankingIcon(int ranking) {
    switch (ranking) {
      case 1:
        return Assets.icons.icRanking1.svg(width: 28.h, height: 28.h);
      case 2:
        return Assets.icons.icRanking2.svg(width: 28.h, height: 28.h);
      case 3:
        return Assets.icons.icRanking3.svg(width: 28.h, height: 28.h);
      default:
        return Assets.icons.icRanking1.svg(width: 28.h, height: 28.h);
    }
  }
}
