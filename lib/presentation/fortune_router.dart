import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_entity.dart';
import 'package:foresh_flutter/presentation/login/bloc/login.dart';

import 'login/login_page.dart';
import 'main/main_ext.dart';
import 'main/main_page.dart';
import 'missiondetail/normal/mission_detail_normal_page.dart';
import 'missiondetail/relay/mission_detail_relay_page.dart';
import 'obtainhistory/obtain_history_page.dart';
import 'onboarding/on_boarding_page.dart';
import 'permission/require_permission_page.dart';

class FortuneRouter {
  late final FluroRouter router;

  static const String param = "landingParam";

  static var mainHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const MainPage();
    },
  );

  static var permissionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const RequestPermissionPage();
    },
  );

  static var missionDetailNormalHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as MissionEntity?;
      return args != null ? MissionDetailNormalPage(args) : null;
    },
  );

  static var missionDetailRelayHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as MissionEntity?;
      return args != null ? MissionDetailRelayPage(args) : null;
    },
  );

  static var onBoardingHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return OnBoardingPage();
    },
  );

  static var loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      String sessionsState = params[param]?.first ?? LoginUserState.none.name;
      final loginParam = () {
        if (sessionsState.contains("needToLogin")) {
          return LoginUserState.needToLogin;
        } else if (sessionsState.contains("sessionExpired")) {
          return LoginUserState.sessionExpired;
        } else {
          return LoginUserState.none;
        }
      }();
      return LoginPage(loginParam);
    },
  );

  static var obtainHistoryHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as MainLandingArgs?;
      return ObtainHistoryPage(searchText: args != null ? args.text : '');
    },
  );

  void init() {
    router = FluroRouter()

      /// 로그인.
      ..define(
        Routes.loginRoute,
        handler: loginHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 로그인 > 세션 만료 인 경우
      ..define(
        "${Routes.loginRoute}/:$param",
        handler: loginHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 메인.
      ..define(
        Routes.mainRoute,
        handler: mainHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 권한요청.
      ..define(
        Routes.requestPermissionRoute,
        handler: permissionHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 온보딩.
      ..define(
        Routes.onBoardingRoute,
        handler: onBoardingHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 노말 미션 상세..
      ..define(
        Routes.missionDetailNormalRoute,
        handler: missionDetailNormalHandler,
        transitionType: TransitionType.cupertino,
      )

     /// 릴레이 미션 상세.
      ..define(
        Routes.missionDetailRelayRoute,
        handler: missionDetailRelayHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 마커 히스토리.
      ..define(
        Routes.obtainHistoryRoute,
        handler: obtainHistoryHandler,
        transitionType: TransitionType.cupertino,
      );
  }
}

class Routes {
  static const String mainRoute = 'mainRoute';
  static const String loginRoute = 'loginRoute';
  static const String onBoardingRoute = 'onBoarding';
  static const String requestPermissionRoute = 'requestPermission';
  static const String obtainHistoryRoute = 'obtainHistory';
  static const String missionDetailNormalRoute = 'missionDetailNormal';
  static const String missionDetailRelayRoute = 'missionDetailRelay';
}
