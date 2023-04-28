import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/checkbox/fortune_check_box.dart';

class MyStampsFilter extends StatelessWidget {
  const MyStampsFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FortuneCheckBox(
          state: false,
          onCheck: () {},
        ),
        SizedBox(width: 8.w),
        Text(
          "교환 가능한 상품만 보기 1",
          style: FortuneTextStyle.body2SemiBold(),
        )
      ],
    );
  }
}
