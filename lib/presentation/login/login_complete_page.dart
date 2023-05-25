import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';

class LoginCompletePage extends StatefulWidget {
  static const tag = "[SignUpCompletePage]";

  const LoginCompletePage({Key? key}) : super(key: key);

  @override
  State<LoginCompletePage> createState() => _LoginCompletePageState();
}

class _LoginCompletePageState extends State<LoginCompletePage> {
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    Timer(const Duration(milliseconds: 2000), () {
      router.navigateTo(
        context,
        Routes.mainRoute,
        clearStack: true,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DelayedDisplay(
              delay: const Duration(milliseconds: 500),
              child: Text(
                'sign_up_complete'.tr(),
                style: FortuneTextStyle.headLine3(),
              ),
            ),
            SizedBox(height: 16),
            DelayedDisplay(
              delay: const Duration(milliseconds: 1000),
              child: Text(
                'move_in_few_minutes'.tr(),
                style: FortuneTextStyle.subTitle3Regular(fontColor: ColorName.activeDark),
              ),
            )
          ],
        ),
      ),
    );
  }
}
