import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_grade_entity.dart';

class ItemRankingContent extends StatelessWidget {
  const ItemRankingContent({
    super.key,
    required this.index,
    required this.profile,
    required this.nickName,
    required this.count,
    required this.grade,
    required this.level,
    this.isMe = false,
  });

  final FortuneUserGradeEntity grade;
  final int level;
  final int index;
  final String profile;
  final String nickName;
  final String count;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _getIndexOrRankIcon(index),
        SizedBox(width: 19.h),
        FortuneCachedNetworkImage(
          width: 48.h,
          height: 48.h,
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
          imageShape: ImageShape.circle,
          fit: BoxFit.fill,
        ),
        SizedBox(width: 16.h),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.only(top: 4.h, left: 6.h, right: 8.h, bottom: 4.h),
                decoration: ShapeDecoration(
                  color: isMe ? ColorName.grey700 : ColorName.grey800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    grade.icon.svg(width: 14.h, height: 14.h),
                    SizedBox(width: 6.h),
                    Text(
                      FortuneTr.msgCenterLevel(level.toString()),
                      style: FortuneTextStyle.caption3Semibold(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  SizedBox(width: 3.h),
                  Text(
                    nickName,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: FortuneTextStyle.body3Semibold(
                      color: ColorName.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 8.h),
        Text(
          FortuneTr.msgItemCount(count),
          style: FortuneTextStyle.body3Semibold(color: ColorName.primary),
        ),
      ],
    );
  }

  _getIndexOrRankIcon(int index) {
    Widget icon;

    switch (index) {
      case 1:
        icon = Assets.icons.icRankGold.svg();
        break;
      case 2:
        icon = Assets.icons.icRankSilver.svg();
        break;
      case 3:
        icon = Assets.icons.icRankBronze.svg();
        break;
      default:
        icon = Padding(
          padding: EdgeInsets.all(8.h),
          child: Text(index.toString(), style: FortuneTextStyle.body3Semibold()),
        );
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [icon],
    );
  }
}
