import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_widget.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_image_view.dart';
import 'package:foresh_flutter/domain/entities/user_grade_entity.dart';

/// 프로필 이미지.
class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required this.profile,
    required this.onNicknameClick,
    required this.onGradeClick,
    required this.nickname,
  });

  final String profile;
  final String nickname;
  final Function0 onNicknameClick;
  final Function0 onGradeClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 20.w),
        SquircleNetworkImageView(
          imageUrl: profile,
          size: 72.h,
          placeHolderPadding: EdgeInsets.all(16.w),
        ),
        SizedBox(width: 20.w),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Nickname(
                nickname: nickname,
                onNicknameClick: onNicknameClick,
              ),
              SizedBox(height: 8.h),
              _Grade(
                onGradeGuideTap: onGradeClick,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _Nickname extends StatelessWidget {
  const _Nickname({
    required this.nickname,
    required this.onNicknameClick,
  });

  final Function0 onNicknameClick;
  final String nickname;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onNicknameClick,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          children: [
            Text(
              nickname,
              style: FortuneTextStyle.subTitle3Bold(),
              overflow: TextOverflow.visible,
            ),
            SizedBox(width: 4.w),
            Assets.icons.icArrowRight20.svg(),
            SizedBox(width: 20.w),
          ],
        ),
      ),
    );
  }
}

class _Grade extends StatelessWidget {
  final Function0 onGradeGuideTap;

  const _Grade({
    super.key,
    required this.onGradeGuideTap,
  });

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onGradeGuideTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: ColorName.backgroundLight,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                getUserGradeIconInfo(1).icon.svg(width: 14.w, height: 14.w),
                SizedBox(width: 8.w),
                Text(
                  getUserGradeIconInfo(1).name,
                  style: FortuneTextStyle.body3Bold(),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            "등급 혜택 보기",
            style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark),
          ),
          SizedBox(width: 4.w),
          Assets.icons.icArrowRight12.svg(width: 12.w, height: 12.w),
        ],
      ),
    );
  }
}
