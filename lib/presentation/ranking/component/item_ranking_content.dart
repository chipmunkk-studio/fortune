import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';

class ItemRankingContent extends StatelessWidget {
  const ItemRankingContent({
    super.key,
    required this.index,
    required this.profile,
    required this.nickName,
    required this.count,
  });

  final String index;
  final String profile;
  final String nickName;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(index, style: FortuneTextStyle.body3Semibold()),
        SizedBox(width: 22.h),
        ClipOval(
          child: FortuneCachedNetworkImage(
            width: 40.h,
            height: 40.h,
            imageUrl: profile,
            errorWidget: Container(
              decoration: BoxDecoration(
                color: ColorName.grey700,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorName.grey700, // 테두리 색을 빨간색으로 설정
                  width: 1.0, // 원하는 테두리 두께
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0.h),
                child: Assets.images.ivDefaultProfile.svg(),
              ),
            ),
            placeholder: Container(),
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(width: 16.h),
        Expanded(
          child: Text(
            nickName,
            style: FortuneTextStyle.body2Semibold(color: ColorName.white, height: 1.3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          FortuneTr.msgItemCount(count),
          style: FortuneTextStyle.body3Light(color: ColorName.grey100),
        ),
      ],
    );
  }
}
