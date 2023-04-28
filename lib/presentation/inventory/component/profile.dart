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
    required this.profile,
  });

  final String profile;

  @override
  Widget build(BuildContext context) {
    return ScaleWidget(
      scaleX: 0.98,
      scaleY: 0.98,
      onTapUp: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 14.w),
          SquircleNetworkImageView(
            imageUrl: profile,
            size: 76.h,
            backgroundColor: ColorName.deActiveDark,
            placeHolder: Assets.images.ivDefaultProfile.svg(fit: BoxFit.cover),
            placeHolderPadding: EdgeInsets.all(16.w),
          ),
          SizedBox(width: 10.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("익명의 다람쥐", style: FortuneTextStyle.subTitle3Bold()),
                  SizedBox(width: 4.w),
                  Assets.icons.rightArrow.svg(),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                "내정보    |    앱설정",
                style: FortuneTextStyle.body3Regular(
                  fontColor: ColorName.activeDark,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
