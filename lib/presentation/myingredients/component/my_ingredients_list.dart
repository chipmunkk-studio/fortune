import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/strings.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/domain/supabase/entity/my_ingredients_view_entity.dart';
import 'package:transparent_image/transparent_image.dart';

class MyIngredientList extends StatelessWidget {
  final Function1<MyIngredientsViewListEntity, void> onTap;

  const MyIngredientList({
    super.key,
    required this.entities,
    required this.onTap,
  });

  final MyIngredientsViewEntity entities;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(left: 29, right: 29, top: 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, // 한 줄에 아이템 5개
        childAspectRatio: 1.0, // 아이템의 가로/세로 비율 (1.0은 정사각형)
        crossAxisSpacing: 8, // 아이템 간의 가로 간격
        mainAxisSpacing: 8, // 아이템 간의 세로 간격
      ),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final item = entities.histories[index];
        return Bounceable(
          onTap: () => onTap(item),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: ColorName.grey700, borderRadius: BorderRadius.circular(16.r)),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  width: 60,
                  height: 60,
                  image: item.ingredient.imageUrl,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text.rich(
                    TextSpan(
                      style: FortuneTextStyle.caption3Semibold().copyWith(
                        shadows: [
                          const Shadow(offset: Offset(-1.0, -1.0), color: ColorName.grey700),
                          const Shadow(offset: Offset(1.0, -1.0), color: ColorName.grey700),
                          const Shadow(offset: Offset(1.0, 1.0), color: ColorName.grey700),
                          const Shadow(offset: Offset(-1.0, 1.0), color: ColorName.grey700),
                        ],
                      ),
                      text: item.histories.length.toString().toFormatThousandNumber(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: entities.histories.length, // 예제를 위해 아이템 20개를 생성
    );
  }
}
