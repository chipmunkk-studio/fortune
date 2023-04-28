import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/signup/bloc/sign_up_bloc.dart';

class SignUpCompletePage extends StatefulWidget {
  static const tag = "[SignUpCompletePage]";

  const SignUpCompletePage({Key? key}) : super(key: key);

  @override
  State<SignUpCompletePage> createState() => _SignUpCompletePageState();
}

class _SignUpCompletePageState extends State<SignUpCompletePage> {
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
  void dispose() {
    serviceLocator.unregister<SignUpBloc>();
    super.dispose();
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
            SizedBox(height: 16.h),
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
