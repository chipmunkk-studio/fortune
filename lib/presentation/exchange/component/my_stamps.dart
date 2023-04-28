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
        title: Text(
          "내가 모은 스탬프",
          style: FortuneTextStyle.body2Regular(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        tilePadding: EdgeInsets.only(
          left: 20.w,
          right: 16.w,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: "123,456", style: FortuneTextStyle.body1SemiBold(fontColor: ColorName.primary)),
                  TextSpan(text: "개", style: FortuneTextStyle.body1SemiBold()),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: 8.w),
            _isExpanded ? Assets.icons.icArrowUp.svg() : Assets.icons.icArrowDown.svg()
          ],
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
