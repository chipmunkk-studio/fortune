import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonMyIngredients extends StatelessWidget {
  const SkeletonMyIngredients({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 24),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 32,
                  width: 120,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          GridView.builder(
            padding: const EdgeInsets.only(left: 29, right: 29, top: 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // 한 줄에 아이템 5개
              childAspectRatio: 1.0, // 아이템의 가로/세로 비율 (1.0은 정사각형)
              crossAxisSpacing: 8, // 아이템 간의 가로 간격
              mainAxisSpacing: 8, // 아이템 간의 세로 간격
            ),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return SkeletonLine(
                style: SkeletonLineStyle(
                  height: 60,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              );
            },
            itemCount: 20, // 예제를 위해 아이템 20개를 생성
          ),
        ],
      ),
    );
  }
}
