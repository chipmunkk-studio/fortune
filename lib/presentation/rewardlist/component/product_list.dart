import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_widget.dart';
import 'package:foresh_flutter/domain/entities/reward_entity.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductList extends StatelessWidget {
  final Function1<int, void> onItemClick;
  final List<RewardProductEntity> rewards;

  const ProductList({
    required this.rewards,
    required this.onItemClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: rewards.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 20.h);
      },
      itemBuilder: (BuildContext context, int index) {
        return Bounceable(
          onTap: () => onItemClick(index),
          child: _ProductItem(rewards[index]),
        );
      },
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem(this.reward);

  final RewardProductEntity reward;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            color: ColorName.backgroundLight,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: ColorName.deActiveDark, width: 1),
                      ),
                      child: Text(
                        reward.name,
                        style: FortuneTextStyle.caption1SemiBold(),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      reward.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: FortuneTextStyle.subTitle3Bold(),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
              SizedBox.square(
                dimension: 92,
                child: ClipOval(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: reward.imageUrl,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ColorName.deActiveDark,
                width: 0.5.h,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 12.h, bottom: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
              color: ColorName.deActiveDark.withOpacity(0.6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${reward.stock}개 남았어요",
                  style: FortuneTextStyle.body3Regular(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                _Recipe(recipe: reward.exchangeableMarkers),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Recipe extends StatelessWidget {
  const _Recipe({
    required this.recipe,
  });

  final List<ExchangeableMarkerEntity> recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recipe
          .map(
            (e) => Row(
              children: [
                e.grade.icon.svg(width: 20.w, height: 20.w),
                SizedBox(width: 4.w),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: "${e.userHaveCount}", style: FortuneTextStyle.body3Bold(fontColor: ColorName.primary)),
                      TextSpan(
                          text: "/${e.count}", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
                    ],
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
