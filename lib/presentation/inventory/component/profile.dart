import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_widget.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_image_view.dart';

/// 프로필 이미지.
class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required this.profile,
    required this.onNicknameClick,
    required this.onGradeBenefitClick,
  });

  final String profile;
  final Function0 onNicknameClick;
  final Function0 onGradeBenefitClick;

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
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScaleWidget(
              scaleX: 0.96,
              scaleY: 0.96,
              onTapUp: onNicknameClick,
              child: Row(
                children: [
                  Text("익명의다람쥐", style: FortuneTextStyle.subTitle3Bold()),
                  SizedBox(width: 4.w),
                  Assets.icons.icArrowRight20.svg(),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "내정보    |    앱설정",
              style: FortuneTextStyle.body3Regular(
                fontColor: ColorName.activeDark,
              ),
            ),
          ],
        )
      ],
    );
  }
}
