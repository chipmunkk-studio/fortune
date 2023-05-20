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
        const SizedBox(width: 20),
        SquircleNetworkImageView(
          imageUrl: profile,
          size: 72,
          placeHolderPadding: const EdgeInsets.all(16),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Nickname(
                nickname: nickname,
                onNicknameClick: onNicknameClick,
              ),
              const SizedBox(height: 8),
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
            const SizedBox(width: 4),
            Assets.icons.icArrowRight20.svg(),
            const SizedBox(width: 20),
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
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorName.backgroundLight,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                getUserGradeIconInfo(1).icon.svg(width: 14, height: 14),
                const SizedBox(width: 8),
                Text(
                  getUserGradeIconInfo(1).name,
                  style: FortuneTextStyle.body3Bold(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "등급 혜택 보기",
            style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark),
          ),
          const SizedBox(width: 4),
          Assets.icons.icArrowRight12.svg(width: 12, height: 12),
        ],
      ),
    );
  }
}
