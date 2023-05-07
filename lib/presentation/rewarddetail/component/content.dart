import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:transparent_image/transparent_image.dart';

class Content extends StatelessWidget {
  final String image;
  final String title;

  const Content({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            _ProductImage(contentImage: image),
            SizedBox(height: 36.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _Title(title: title),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text("교환 시 필요한 포춘", style: FortuneTextStyle.body2Regular(fontColor: ColorName.activeDark)),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 36.h,
              child: _NeedFortuneArea(),
            ),
            SizedBox(height: 36.h),
            Divider(
              thickness: 12.h,
              color: ColorName.backgroundLight,
            ),
            Column(
              children: [
                Text("유의사항만 적읍시다.",style: FortuneTextStyle.body2Regular(),),
              ],
            )
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  ColorName.background.withOpacity(1.0),
                  ColorName.background.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NeedFortuneArea extends StatelessWidget {
  const _NeedFortuneArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              color: ColorName.deActiveDark.withOpacity(0.4),
            ),
            padding: EdgeInsets.only(left: 8.w, top: 7.h, bottom: 7.h, right: 12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.icons.icFortuneDiamond.svg(width: 20, height: 20),
                SizedBox(width: 8.w),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "153",
                        style: FortuneTextStyle.body2SemiBold(
                          fontColor: ColorName.primary,
                        ),
                      ),
                      TextSpan(
                        text: "/50",
                        style: FortuneTextStyle.body2SemiBold(
                          fontColor: ColorName.activeDark,
                        ),
                      ),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            style: FortuneTextStyle.headLine3(),
          ),
        ),
        SizedBox(width: 84.w),
      ],
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    super.key,
    required this.contentImage,
  });

  final String contentImage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox.square(
        dimension: 280.w,
        child: ClipOval(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: contentImage,
          ),
        ),
      ),
    );
  }
}
