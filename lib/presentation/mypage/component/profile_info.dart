import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_widget.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_image_view.dart';
import 'package:foresh_flutter/presentation/fortune_ext.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ScaleWidget(
          scaleX: 0.96,
          scaleY: 0.96,
          onTapUp: () {},
          child: Stack(
            children: [
              SquircleNetworkImageView(
                imageUrl: getSampleNetworkImageUrl(width: 84, height: 84),
                size: 84,
                placeHolder: Assets.images.ivDefaultProfile.svg(fit: BoxFit.cover),
                placeHolderPadding: EdgeInsets.all(16.w),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox.square(
                  dimension: 20.w,
                  child: ClipOval(
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(4.w),
                      child: Assets.icons.icPencil.svg(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  "열두글자로한다고라고라고",
                  style: FortuneTextStyle.subTitle3Bold(),
                ),
                SizedBox(width: 8.w),
                ScaleWidget(
                  onTapUp: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
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
            ),
            SizedBox(height: 8.h),
            ScaleWidget(
              scaleX: 0.98,
              scaleY: 0.98,
              onTapUp: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        getGradeIconInfo(1, size: 14.w).icon,
                        SizedBox(width: 8.w),
                        Text(
                          getGradeIconInfo(1, size: 14.w).name,
                          style: FortuneTextStyle.body3Bold(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "등급안내",
                    style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark),
                  ),
                  SizedBox(width: 4.w),
                  Assets.icons.icArrowRight12.svg(width: 12.w, height: 12.w),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
