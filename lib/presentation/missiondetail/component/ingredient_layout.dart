import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/core/widgets/painter/squircle_painter.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_detail_entity.dart';

class IngredientLayout extends StatelessWidget {
  final List<MissionDetailViewItemEntity> _viewItems;

  const IngredientLayout(
    this._viewItems, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _viewItems.isNotEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildIngredient(_viewItems[0]),
                    const SizedBox(width: 26),
                    _buildIngredient(_viewItems[1]),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    _buildIngredient(_viewItems[2]),
                    const SizedBox(width: 26),
                    _buildIngredient(_viewItems[3]),
                    const SizedBox(width: 26),
                    _buildIngredient(_viewItems[4]),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildIngredient(_viewItems[5]),
                    const SizedBox(width: 26),
                    _buildIngredient(_viewItems[6]),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildIngredient(MissionDetailViewItemEntity item) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 148.h,
            minHeight: 120.h,
            maxWidth: 100.h,
            minWidth: 100.h,
          ),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: CustomPaint(
                  painter: SquirclePainter(color: ColorName.grey800),
                  child: item.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          child: Assets.icons.icLock.svg(
                            width: 44,
                            height: 44,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          child: FortuneCachedNetworkImage(
                            width: 68,
                            height: 68,
                            imageUrl: item.ingredient.imageUrl,
                            placeholder: Container(),
                            fit: BoxFit.fill,
                          ),
                        ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Align(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: ColorName.grey800,
                      border: Border.all(
                        color: ColorName.grey900,
                        width: 2,
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${item.haveCount}",
                            style: FortuneTextStyle.caption3Semibold(color: ColorName.primary),
                          ),
                          TextSpan(
                            text: "/${item.requireCount}",
                            style: FortuneTextStyle.caption3Semibold(color: ColorName.grey500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Text(
                item.ingredient.exposureName.isEmpty ? '-' : item.ingredient.exposureName,
                textAlign: TextAlign.center,
                style: FortuneTextStyle.body3Light(),
              )
            ],
          ),
        )
      ],
    );
  }
}
