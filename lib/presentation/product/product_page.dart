import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/presentation/product/component/content.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 0),
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: ""),
      child: _ProductPage(),
    );
  }
}

class _ProductPage extends StatefulWidget {
  const _ProductPage({Key? key}) : super(key: key);

  @override
  State<_ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<_ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Content(
            image: "https://source.unsplash.com/user/max_duz/360x360",
            title: "스타벅스 아이스 카페\n아메리카노 Tall",
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: FortuneBottomButton(
            isEnabled: true,
            buttonText: "교환하기",
            onPress: () => context.showFortuneBottomSheet(
              content: (context) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "스타벅스 아이스 카페 아메리카노",
                        style: FortuneTextStyle.headLine1(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "50개가 차감되며, 회원정보에 등록된 휴대폰 메세지로 모바일 상품권이 발송됩니다. 지금받으시겠습니까?",
                        textAlign: TextAlign.center,
                        style: FortuneTextStyle.body2Regular(),
                      ),
                      SizedBox(height: 16.h),
                      FortuneBottomButton(
                        isEnabled: true,
                        onPress: () {},
                        buttonText: "교환",
                        isKeyboardVisible: false,
                      ),
                    ],
                  ),
                );
              },
            ),
            isKeyboardVisible: false,
          ),
        ),
      ],
    );
  }
}
