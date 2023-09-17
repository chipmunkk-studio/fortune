import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/painter/squircle_image_view.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_grade_entity.dart';

class ProfileInfo extends StatelessWidget {
  final FortuneUserEntity entity;
  final Function0 onGradeGuideTap;
  final Function0 onProfileTap;
  final Function0 onNicknameModifyTap;

  const ProfileInfo({
    super.key,
    required this.entity,
    required this.onGradeGuideTap,
    required this.onProfileTap,
    required this.onNicknameModifyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfileImage(
          profileUrl: entity.profileImage,
          onProfileTap: onProfileTap,
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            children: [
              _Nickname(
                nickName: entity.nickname,
                onNicknameModifyTap: onNicknameModifyTap,
              ),
              const SizedBox(height: 8),
              _Grade(
                entity: entity.grade,
                onGradeGuideTap: onGradeGuideTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileImage extends StatelessWidget {
  final Function0 onProfileTap;
  final String profileUrl;

  const _ProfileImage({
    super.key,
    required this.onProfileTap,
    required this.profileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onProfileTap,
      child: Stack(
        children: [
          SquircleNetworkImageView(
            imageUrl: profileUrl,
            size: 84,
            placeHolder: Assets.images.ivDefaultProfile.svg(fit: BoxFit.cover),
            placeHolderPadding: const EdgeInsets.all(16),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox.square(
              dimension: 24,
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(4),
                  child: Assets.icons.icPencil.svg(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Nickname extends StatelessWidget {
  final Function0 onNicknameModifyTap;
  final String nickName;

  const _Nickname({
    required this.onNicknameModifyTap,
    required this.nickName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              nickName,
              style: FortuneTextStyle.subTitle2SemiBold(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Bounceable(
          onTap: onNicknameModifyTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: ColorName.grey500, width: 1),
            ),
            child: Text(
              FortuneTr.modify,
              style: FortuneTextStyle.caption3Semibold(),
            ),
          ),
        ),
      ],
    );
  }
}

class _Grade extends StatelessWidget {
  final Function0 onGradeGuideTap;
  final FortuneUserGradeEntity entity;

  const _Grade({
    required this.onGradeGuideTap,
    required this.entity,
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
              borderRadius: BorderRadius.circular(16.r),
              color: ColorName.grey800,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                getUserGradeIconInfo(entity.grade).icon.svg(width: 20, height: 20),
                const SizedBox(width: 8),
                Text(
                  getUserGradeIconInfo(entity.grade).name,
                  style: FortuneTextStyle.body3Semibold(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            FortuneTr.gradeGuide,
            style: FortuneTextStyle.body3Light(fontColor: ColorName.grey200),
          ),
          const SizedBox(width: 4),
          Assets.icons.icArrowRight12.svg(width: 12, height: 12),
        ],
      ),
    );
  }
}
