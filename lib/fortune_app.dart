import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/navigation/fortune_web_router.dart';
import 'package:fortune/di.dart';
import 'package:skeletons/skeletons.dart';

import 'core/util/theme.dart';

class FortuneApp extends StatelessWidget {
  final String startRoute;
  final bool isWebInApp;

  const FortuneApp({
    super.key,
    required this.startRoute,
    required this.isWebInApp,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: ColorName.grey900,
        width: isWebInApp ? null : 540,
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          splitScreenMode: false,
          minTextAdapt: true,
          rebuildFactor: RebuildFactors.change,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              // 화면 비율 일정 하도록 함.
              data: MediaQueryData.fromView(View.of(context)).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: _buildApp(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildApp(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [
          ColorName.grey700,
          ColorName.grey600,
          ColorName.grey600,
          ColorName.grey800,
          ColorName.grey600,
          ColorName.grey600,
          ColorName.grey700,
        ],
        stops: [0.3, 0.5, 0.7, 0.9, 0.7, 0.5, 0.3],
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [serviceLocator<RouteObserver<PageRoute>>()],
        theme: theme(),
        onGenerateRoute: _getRouter(),
        initialRoute: startRoute,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }

  _getRouter() {
    if (kIsWeb) {
      return serviceLocator<FortuneWebRouter>().router.generator;
    } else {
      return serviceLocator<FortuneAppRouter>().router.generator;
    }
  }
}
