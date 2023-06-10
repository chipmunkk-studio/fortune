import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/presentation/login/bloc/login.dart';

import 'login/login_page.dart';
import 'main/main_page.dart';
import 'onboarding/on_boarding_page.dart';
import 'permission/require_permission_page.dart';
import 'rewardhistory/reward_history_page.dart';

class FortuneRouter {
  late final FluroRouter router;

  static const String paramLandingPage = "paramLandingPage";
  static const String paramSessionState = "paramSessionState";

  static var mainHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      String? landingRoute = params[paramLandingPage]?.first;
      return MainPage(landingRoute);
    },
  );

  static var permissionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const RequestPermissionPage();
    },
  );

  static var onBoardingHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return OnBoardingPage();
    },
  );

  static var loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      String sessionsState = params[paramSessionState]?.first ?? LoginUserState.none.name;
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

  static var rewardHistoryHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const RewardHistoryPage();
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
        "${Routes.loginRoute}/:$paramSessionState",
        handler: loginHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 메인 > 랜딩 페이지가 있는 경우.
      ..define(
        "${Routes.mainRoute}/:$paramLandingPage",
        handler: mainHandler,
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

      /// 마커 히스토리.
      ..define(
        Routes.rewardHistoryRoute,
        handler: rewardHistoryHandler,
        transitionType: TransitionType.cupertino,
      );
  }
}

class Routes {
  static const String mainRoute = 'mainRoute';
  static const String loginRoute = 'loginRoute';
  static const String onBoardingRoute = 'onBoarding';
  static const String requestPermissionRoute = 'requestPermission';
  static const String rewardHistoryRoute = 'rewardHistory';
}
