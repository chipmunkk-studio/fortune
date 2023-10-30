import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

import 'my_ingredients_list.dart';

class SkeletonMyIngredients extends StatelessWidget {
  const SkeletonMyIngredients({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420.h,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 24.h),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 32.h,
                  width: 120.h,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          GridView.builder(
            padding: EdgeInsets.only(left: 29.h, right: 29.h, top: 0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // 한 줄에 아이템 5개
              childAspectRatio: 1.0, // 아이템의 가로/세로 비율 (1.0은 정사각형)
              crossAxisSpacing: 8.h, // 아이템 간의 가로 간격
              mainAxisSpacing: 8.h, // 아이템 간의 세로 간격
            ),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return SkeletonLine(
                style: SkeletonLineStyle(
                  height: MyIngredientList.getImageSize(context),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              );
            },
            itemCount: 10, // 예제를 위해 아이템 20개를 생성
          ),
        ],
      ),
    );
  }
}
