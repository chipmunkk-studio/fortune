import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_painter.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/normal_mission_detail_entity.dart';
import 'package:transparent_image/transparent_image.dart';

class IngredientLayout extends StatelessWidget {
  final List<NormalMissionDetailViewItemEntity> _viewItems;

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
                SizedBox(width: 20.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildIngredient(_viewItems[0]),
                    SizedBox(width: 26.h),
                    _buildIngredient(_viewItems[1]),
                  ],
                ),
                SizedBox(height: 28.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildIngredient(_viewItems[2]),
                    _buildIngredient(_viewItems[3]),
                    _buildIngredient(_viewItems[4]),
                  ],
                ),
                SizedBox(height: 28.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildIngredient(_viewItems[5]),
                    SizedBox(width: 26.h),
                    _buildIngredient(_viewItems[6]),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildIngredient(NormalMissionDetailViewItemEntity item) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 148.h,
            minHeight: 148.h,
            maxWidth: 100.h,
            minWidth: 100.h,
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: CustomPaint(
                  painter: SquirclePainter(color: ColorName.backgroundLight),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: item.isEmpty
                        ? Assets.icons.icLock.svg(
                            width: 68.h,
                            height: 68.h,
                          )
                        : FadeInImage.memoryNetwork(
                            width: 68.h,
                            height: 68.h,
                            placeholder: kTransparentImage,
                            image: item.ingredient.imageUrl,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: ColorName.backgroundLight,
                    border: Border.all(
                      color: ColorName.background,
                      width: 2.h,
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${item.haveCount}",
                          style: FortuneTextStyle.caption1SemiBold(fontColor: ColorName.primary),
                        ),
                        TextSpan(
                          text: "/${item.requireCount}",
                          style: FortuneTextStyle.caption1SemiBold(fontColor: ColorName.deActive),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  item.ingredient.name.isEmpty ? '-' : item.ingredient.name,
                  style: FortuneTextStyle.body3Regular(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
