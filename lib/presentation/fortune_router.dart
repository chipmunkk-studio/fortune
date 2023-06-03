import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'board/board_page.dart';
import 'login/login_page.dart';
import 'onboarding/on_boarding_page.dart';
import 'permission/require_permission_page.dart';

class FortuneRouter {
  late final FluroRouter router;

  static var homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return BoardPage();
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
      return const LoginPage();
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

    /// 홈.
      ..define(
        Routes.homeRoute,
        handler: homeHandler,
        transitionType: TransitionType.cupertino,
      );
  }
}

class Routes {
  static const String homeRoute = 'homeRoute';
  static const String loginRoute = 'loginRoute';
  static const String onBoardingRoute = 'onBoarding';
  static const String requestPermissionRoute = 'requestPermission';
}