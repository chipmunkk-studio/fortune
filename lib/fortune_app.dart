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

  const FortuneApp(
    this.startRoute, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(390, 844),
        splitScreenMode: false,
        minTextAdapt: true,
        rebuildFactor: RebuildFactors.change,
        builder: (BuildContext context, Widget? child) {
          if (_isDesktop(context)) {
            return Center(
              child: SizedBox(
                width: 600,
                height: MediaQuery.of(context).size.height,
                child: _buildAppContent(context),
              ),
            );
          }
          return _buildAppContent(context);
        },
      );

  Widget _buildAppContent(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromView(WidgetsBinding.instance.window).copyWith(textScaleFactor: 1.0),
      child: SkeletonTheme(
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
      ),
    );
  }

  RouteFactory _getRouter() {
    if (kIsWeb) {
      return serviceLocator<FortuneWebRouter>().router.generator;
    } else {
      return serviceLocator<FortuneAppRouter>().router.generator;
    }
  }

  bool _isDesktop(BuildContext context) {
    if (kIsWeb) {
      final width = MediaQuery.of(context).size.width;
      return width > 800; // 임의의 값을 설정하여 데스크탑 크기를 판별. 필요에 따라 수정 가능.
    }
    return false;
  }
}
