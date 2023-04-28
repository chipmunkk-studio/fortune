import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_scale_button.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';

class OnBoardingPage extends StatelessWidget {
  final router = serviceLocator<FortuneRouter>().router;

  OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tr("onboarding_greeting_title"), style: FortuneTextStyle.headLine3()),
          Text(tr("onboarding_greeting_sub_title"), style: FortuneTextStyle.body1Regular()),
          SizedBox(height: 24.h),
          FortuneScaleButton(
            text: 'join_membership'.tr(),
            press: () => router.navigateTo(
              context,
              Routes.phoneNumberRoute,
            ),
          )
        ],
      ),
    );
  }
}
