import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_scale_button.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_ext.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';

class OnBoardingPage extends StatefulWidget {

  OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Text(
            tr("onboarding_greeting_title"),
            style: FortuneTextStyle.headLine2(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            tr("onboarding_greeting_sub_title"),
            style: FortuneTextStyle.subTitle2SemiBold(
              fontColor: ColorName.grey200,
            ),
            textAlign: TextAlign.center,
          ),
          Assets.icons.icOnboarding.svg(),
          const Spacer(),
          FortuneScaleButton(
            text: 'next'.tr(),
            press: () => router.navigateTo(
              context,
              Routes.requestPermissionRoute,
            ),
          )
        ],
      ),
    );
  }
}
