import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/navigation/fortune_web_router.dart';
import 'package:fortune/data/supabase/service/auth_service.dart';

import '../di.dart';
import '../fortune_app.dart';
import 'env.dart';

main() {
  runZonedGuarded(
    () async {
      /// di 설정.
      await init();
      // Flutter 프레임워크에서 발생하는 특정 에러들, 예를 들어 위젯 라이프사이클에서 발생하는 에러
      // 등은 runZonedGuarded를 통해 잡히지 않을 수 있음.
      // FlutterError.onError는 Flutter 프레임워크 에러를 처리하고,
      // runZonedGuarded는 그 외 Dart 수준에서 발생하는 예외를 처리함.
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      final remoteMessageData = initialMessage?.data;

      String startRoute = kIsWeb
          ? WebRoutes.loginRoute
          : await getStartRoute(
              remoteMessageData,
            );

      final isWebInApp = serviceLocator<Environment>().isWebInApp;

      runApp(
        EasyLocalization(
          supportedLocales: Environment.supportedLocales,
          path: Environment.translation,
          fallbackLocale: const Locale('ko', 'KR'),
          child: FortuneApp(
            startRoute: startRoute,
            isWebInApp: isWebInApp,
          ),
        ),
      );
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(
      error.toString(),
      stack,
      fatal: true,
    ),
  );
}
