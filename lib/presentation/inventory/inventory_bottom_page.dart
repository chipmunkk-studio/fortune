import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/inventory/component/profile.dart';
import 'package:foresh_flutter/presentation/inventory/component/stamp_exchange.dart';
import 'package:foresh_flutter/presentation/inventory/component/stamps.dart';

class InventoryBottomPage extends StatelessWidget {
  final String profile;
  final List<int> stamps;
  final router = serviceLocator<FortuneRouter>().router;

  InventoryBottomPage({
    super.key,
    required this.profile,
    required this.stamps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Profile(
          profile: profile,
          onGradeBenefitClick: () {},
          onNicknameClick: () => router.navigateTo(context, Routes.myPageRoute),
          onGradeClick: () => router.navigateTo(context, Routes.gradeGuideRoute),
        ),
        SizedBox(height: 36.h),
        StampExchange(
          onStampExchangeClick: () => _navigateToExchangePage(context),
        ),
        SizedBox(height: 33.h),
        Stamps(
          top: stamps.take(2).toList(),
          center: stamps.skip(2).take(3).toList(),
          bottom: stamps.skip(5).toList(),
          onStampClick: () => _navigateToExchangePage(context),
        )
      ],
    );
  }

  _navigateToExchangePage(BuildContext context) {
    router.navigateTo(
      context,
      Routes.exchangeRoute,
    );
  }
}
