import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/painter/squircle_painter.dart';
import 'package:fortune/domain/supabase/entity/obtain_history_entity.dart';
import 'package:fortune/presentation/main/main_ext.dart';

class ItemObtainHistory extends StatelessWidget {
  final ObtainHistoryContentViewItem item;

  const ItemObtainHistory(
    this.item, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomPaint(
                painter: SquirclePainter(color: ColorName.grey800),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: item.ingredient.image.imageUrl.isEmpty
                      ? Assets.icons.icLock.svg(
                          width: 24,
                          height: 24,
                        )
                      : buildIngredientByPlayType(
                          item.ingredient,
                          width: 24,
                          height: 24,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: Text(item.ingredientName, style: FortuneTextStyle.body1Semibold())),
                        const SizedBox(width: 8),
                        Text(
                          item.createdAt,
                          style: FortuneTextStyle.caption2Regular(color: ColorName.grey200),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      FortuneTr.msgAcquireMarker(item.nickName, item.locationName, item.ingredientName),
                      style: FortuneTextStyle.body3Regular(color: ColorName.grey200, height: 1.4),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
