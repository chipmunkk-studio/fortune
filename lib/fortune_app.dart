import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/di.dart';
import 'package:skeletons/skeletons.dart';

import 'core/util/theme.dart';
import 'presentation/fortune_router.dart';

class FortuneApp extends StatelessWidget {
  final String startRoute;

  const FortuneApp(
    this.startRoute, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(390, 844),
        splitScreenMode: false,
        minTextAdapt: true,
        rebuildFactor: RebuildFactors.all,
        builder: (BuildContext context, Widget? child) {
          /// 강제로 언어를 한글로 설정. 배포 시 삭제해야 함.
          // EasyLocalization.of(context)?.setLocale(const Locale('en', 'US'));
          EasyLocalization.of(context)?.setLocale(const Locale('ko', 'KR'));
          return MediaQuery(
            // 화면 비율 일정 하도록 함.
            data: MediaQueryData.fromView(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1.0),
            child: SkeletonTheme(
              shimmerGradient: const LinearGradient(
                colors: [
                  ColorName.backgroundLight,
                  ColorName.deActiveDark,
                  ColorName.backgroundLight,
                  ColorName.deActiveDark,
                  ColorName.backgroundLight,
                ],
                stops: [0.1, 0.5, 0.9, 0.5, 0.9],
              ),
              child: MaterialApp(
                // 기본적으로 필요한 언어 설정
                debugShowCheckedModeBanner: false,
                title: "Fortune",
                theme: theme(),
                onGenerateRoute: serviceLocator<FortuneRouter>().router.generator,
                initialRoute: startRoute,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
              ),
            ),
          );
        },
      );
}
