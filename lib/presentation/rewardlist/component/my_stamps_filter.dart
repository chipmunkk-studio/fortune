import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/checkbox/fortune_check_box.dart';

class MyStampsFilter extends StatelessWidget {
  const MyStampsFilter(
    this.isChangeableChecked, {
    Key? key,
    required this.onCheck,
  }) : super(key: key);

  final bool isChangeableChecked;
  final Function1<bool?, void> onCheck;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FortuneCheckBox(
          state: isChangeableChecked,
          onCheck: onCheck,
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => onCheck(isChangeableChecked),
          child: Text(
            "교환 가능한 상품만 보기 1",
            style: FortuneTextStyle.body2SemiBold(),
          ),
        )
      ],
    );
  }
}
