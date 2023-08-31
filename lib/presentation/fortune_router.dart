import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/notification/notification_response.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_view_entity.dart';
import 'package:foresh_flutter/presentation/alarmfeed/alarm_feed_page.dart';
import 'package:foresh_flutter/presentation/alarmreward/alarm_reward_page.dart';
import 'package:foresh_flutter/presentation/login/bloc/login.dart';
import 'package:foresh_flutter/presentation/termsdetail/terms_detail_page.dart';

import 'ingredientaction/ingredient_action_page.dart';
import 'login/login_page.dart';
import 'main/main_ext.dart';
import 'main/main_page.dart';
import 'missiondetail/mission_detail_page.dart';
import 'obtainhistory/obtain_history_page.dart';
import 'onboarding/on_boarding_page.dart';
import 'permission/require_permission_page.dart';

class FortuneRouter {
  late final FluroRouter router;

  static const String loginParam = "loginParam";
  static const String mainParam = "mainParam";
  static const String termsParam = "termsParam";

  static var mainHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final data = params[mainParam]?.first.toString() ?? '';
      if (data.isNotEmpty) {
        Map<String, dynamic> decodedMap = jsonDecode(params[mainParam]?.first ?? '');
        FortuneNotificationEntity notification = FortuneNotificationResponse.fromJson(decodedMap);
        return MainPage(notification);
      } else {
        return const MainPage(null);
      }
    },
  );

  static var permissionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const RequestPermissionPage();
    },
  );

  static var missionDetailNormalHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as MissionViewEntity?;
      return args != null ? MissionDetailPage(args) : null;
    },
  );

  static var onBoardingHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return OnBoardingPage();
    },
  );

  static var termsDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      int? data;
      var paramValue = params[termsParam]?.first;
      if (paramValue != null) {
        data = int.tryParse(paramValue);
      }
      return data != null ? TermsDetailPage(data) : null;
    },
  );

  static var ingredientActionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as IngredientActionParam?;
      return args != null ? IngredientActionPage(args) : null;
    },
  );

  static var loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      String sessionsState = params[loginParam]?.first ?? LoginUserState.none.name;
      final loginUserState = () {
        if (sessionsState.contains("needToLogin")) {
          return LoginUserState.needToLogin;
        } else {
          return LoginUserState.none;
        }
      }();
      return LoginPage(loginUserState);
    },
  );

  static var obtainHistoryHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as MainLandingArgs?;
      return ObtainHistoryPage(searchText: args != null ? args.text : '');
    },
  );

  static var alarmFeedHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const AlarmFeedPage();
    },
  );

  static var alarmRewardHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as int?;
      return args != null ? AlarmRewardPage(args) : null;
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
        "${Routes.loginRoute}/:$loginParam",
        handler: loginHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 메인.
      ..define(
        Routes.mainRoute,
        handler: mainHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 메인. > 노티피케이션
      ..define(
        "${Routes.mainRoute}/:$mainParam",
        handler: mainHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 권한 요청.
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

      /// 재료 획득 액션.
      ..define(
        Routes.ingredientActionRoute,
        opaque: false,
        handler: ingredientActionHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 노말 미션 상세.
      ..define(
        Routes.missionDetailNormalRoute,
        handler: missionDetailNormalHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 알림 피드.
      ..define(
        Routes.alarmFeedRoute,
        handler: alarmFeedHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 알림 보상.
      ..define(
        Routes.alarmRewardRoute,
        handler: alarmRewardHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 약관 상세.
      ..define(
        "${Routes.termsDetailRoute}/:$termsParam",
        handler: termsDetailHandler,
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
  static const String mainRoute = 'main';
  static const String loginRoute = 'login';
  static const String onBoardingRoute = 'onBoarding';
  static const String requestPermissionRoute = 'requestPermission';
  static const String obtainHistoryRoute = 'obtainHistory';
  static const String alarmFeedRoute = 'alarmFeed';
  static const String alarmRewardRoute = 'alarmReward';
  static const String missionDetailNormalRoute = 'missionDetailNormal';
  static const String ingredientActionRoute = 'ingredientAction';
  static const String userNoticesRoute = 'userNotices';
  static const String termsDetailRoute = 'termsDetail';
}
