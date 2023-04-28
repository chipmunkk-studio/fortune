import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductList extends StatelessWidget {
  const ProductList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: 10,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 20.h);
      },
      itemBuilder: (BuildContext context, int index) {
        // Why network for web?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return _ProductItem();
      },
    );
  }
}

class _ProductItem extends StatelessWidget {
  const _ProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h, bottom: 20.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
            color: ColorName.backgroundLight,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: ColorName.deActiveDark, width: 1),
                      ),
                      child: Text(
                        "카페/베이커리",
                        style: FortuneTextStyle.caption1SemiBold(),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "스타벅스 아이스 카페 아메리카노 Tall",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: FortuneTextStyle.subTitle3Bold(),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
              SizedBox.square(
                dimension: 92,
                child: ClipOval(
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: "https://source.unsplash.com/user/max_duz/92x92",
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: ColorName.deActiveDark,
                width: 0.5.h,
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 12.h, bottom: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
              color: ColorName.deActiveDark.withOpacity(0.6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "1,234개 남았어요",
                  style: FortuneTextStyle.body3Regular(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Assets.icons.icFortuneDiamond.svg(width: 20, height: 20),
                SizedBox(width: 4.w),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "153", style: FortuneTextStyle.body3Bold(fontColor: ColorName.primary)),
                      TextSpan(text: "/50", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
