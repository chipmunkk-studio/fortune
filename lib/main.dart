import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../di.dart';
import '../fortune_app.dart';
import 'env.dart';

main() async {
  /// di 설정.
  await init();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // 앱이 백그라운드 상태에서 알림을 클릭하여 시작된 경우 > 루트를 넘겨줘야함
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  String startRoute = await getStartRoute(initialMessage?.data);

  runZonedGuarded(
    () async {
      runApp(
        EasyLocalization(
          // 지원 언어 리스트
          supportedLocales: Environment.supportedLocales,
          // path: 언어 파일 경로
          path: Environment.translation,
          // supportedLocales에 설정한 언어가 없는 경우 설정되는 언어
          fallbackLocale: const Locale('en', 'US'),
          // startLocale을 지정하면 초기 언어가 설정한 언어로 변경됨.
          // 만일 이 설정을 하지 않으면 OS 언어를 따라 기본 언어가 설정됨.
          // startLocale: Locale('ko', 'KR')
          child: FortuneApp(startRoute),
        ),
      );
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    ),
  );
}