import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_image_view.dart';

class MyStamps extends StatefulWidget {
  const MyStamps({Key? key}) : super(key: key);

  @override
  State<MyStamps> createState() => _MyStampsState();
}

class _MyStampsState extends State<MyStamps> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      color: ColorName.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Assets.icons.icInventory.svg(width: 16, height: 16),
                SizedBox(width: 8.w),
                Text(
                  "내가 보유한 포춘",
                  style: FortuneTextStyle.body2Regular(fontColor: ColorName.activeDark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text("2개", style: FortuneTextStyle.subTitle2Bold()),
            SizedBox(height: 16.h),
          ],
        ),
        trailing: Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: _isExpanded
              ? Assets.icons.icArrowUp.svg(width: 20, height: 20)
              : Assets.icons.icArrowDown.svg(width: 20, height: 20),
        ),
        tilePadding: EdgeInsets.only(
          left: 24.w,
          right: 20.w,
        ),
        onExpansionChanged: (bool isExpanded) {
          setState(() {
            _isExpanded = isExpanded;
          });
        },
        initiallyExpanded: _isExpanded,
        children: [
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            shrinkWrap: true,
            mainAxisSpacing: 12.w,
            crossAxisSpacing: 12.w,
            padding: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 20.h, top: 8.h),
            children: List.generate(
              8,
              (index) {
                return SquircleNetworkImageView(
                  imageUrl: "https://source.unsplash.com/user/max_duz/68x68",
                  backgroundColor: ColorName.deActiveDark.withOpacity(0.4),
                  size: 76,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
