import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_exchangeable_marker_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_product_entity.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductList extends StatefulWidget {
  final dartz.Function1<int, void> onItemClick;
  final List<RewardProductPagingEntity> rewards;
  final dartz.Function0 onNextPage;

  const ProductList({
    required this.rewards,
    required this.onItemClick,
    required this.onNextPage,
    super.key,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: widget.rewards.length,
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 20),
      itemBuilder: (BuildContext context, int index) {
        final item = widget.rewards[index];
        if (item is RewardProductEntity) {
          return Bounceable(
            onTap: () => widget.onItemClick(item.rewardId),
            child: _ProductItem(item),
          );
        } else {
          return const Center(
            child: SizedBox.square(
              dimension: 32,
              child: CircularProgressIndicator(
                color: ColorName.primary,
              ),
            ),
          );
        }
      },
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const tolerance = 0.1; // You can adjust this value
    if (currentScroll <= maxScroll - tolerance &&
        _scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      widget.onNextPage();
    }
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
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
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
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: ColorName.deActiveDark, width: 1),
                      ),
                      child: Text(
                        reward.name,
                        style: FortuneTextStyle.caption1SemiBold(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      reward.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: FortuneTextStyle.subTitle3Bold(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
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
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ColorName.deActiveDark,
                width: 0.5,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
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

  final List<RewardExchangeableMarkerEntity> recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recipe
          .map(
            (e) => Row(
              children: [
                e.grade.icon.svg(width: 20, height: 20),
                const SizedBox(width: 4),
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
