import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_image_view.dart';
import 'package:foresh_flutter/domain/entities/user_grade_entity.dart';
import 'package:foresh_flutter/presentation/fortune_ext.dart';

class ProfileInfo extends StatelessWidget {
  final Function0 onGradeGuideTap;
  final Function0 onProfileTap;
  final Function0 onNicknameModifyTap;

  const ProfileInfo({
    super.key,
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
          onProfileTap: onProfileTap,
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            children: [
              _Nickname(
                onNicknameModifyTap: onNicknameModifyTap,
              ),
              const SizedBox(height: 8),
              _Grade(
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

  const _ProfileImage({
    super.key,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onProfileTap,
      child: Stack(
        children: [
          SquircleNetworkImageView(
            imageUrl: getSampleNetworkImageUrl(width: 84, height: 84),
            size: 84,
            placeHolder: Assets.images.ivDefaultProfile.svg(fit: BoxFit.cover),
            placeHolderPadding: const EdgeInsets.all(16),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox.square(
              dimension: 20,
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(4),
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

  const _Nickname({
    required this.onNicknameModifyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "열두글자로한다고라고라고라고asfadfa",
              style: FortuneTextStyle.subTitle3Bold(),
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
              border: Border.all(color: ColorName.deActiveDark, width: 1),
            ),
            child: Text(
              "수정",
              style: FortuneTextStyle.caption1SemiBold(),
            ),
          ),
        ),
      ],
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
              borderRadius: BorderRadius.circular(8.r),
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
          SizedBox(width: 12),
          Text(
            "등급안내",
            style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark),
          ),
          SizedBox(width: 4),
          Assets.icons.icArrowRight12.svg(width: 12, height: 12),
        ],
      ),
    );
  }
}
