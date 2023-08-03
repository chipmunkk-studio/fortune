import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_notices.dart';
import 'package:foresh_flutter/data/supabase/request/request_obtain_history.dart';
import 'package:foresh_flutter/data/supabase/service/auth_service.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/repository/ingredient_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';

import '../di.dart';
import '../fortune_app.dart';
import 'domain/supabase/repository/alarm_feeds_repository.dart';
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

      String startRoute = await serviceLocator<AuthService>().recoverSession();

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
