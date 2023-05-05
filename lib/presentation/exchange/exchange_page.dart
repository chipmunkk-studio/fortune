import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/exchange/component/my_stamps.dart';
import 'package:foresh_flutter/presentation/exchange/component/my_stamps_filter.dart';
import 'package:foresh_flutter/presentation/exchange/component/product_list.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';

class ExchangePage extends StatelessWidget {
  const ExchangePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "스탬프 교환소"),
      child: _ExchangePage(),
    );
  }
}

class _ExchangePage extends StatefulWidget {
  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<_ExchangePage> {
  final router = serviceLocator<FortuneRouter>().router;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MyStamps(),
        SizedBox(height: 32.h),
        const MyStampsFilter(),
        SizedBox(height: 16.h),
        Expanded(
          child: Stack(
            children: [
              ProductList(
                onItemClick: (item) {
                  router.navigateTo(context, Routes.productRoute);
                },
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
          ),
        )
      ],
    );
  }
}
