import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/notification/notification_response.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_view_entity.dart';
import 'package:fortune/presentation/alarmfeed/alarm_feed_page.dart';
import 'package:fortune/presentation/alarmreward/alarm_reward_page.dart';
import 'package:fortune/presentation/countrycode/country_code_page.dart';
import 'package:fortune/presentation/gradeguide/grade_guide_page.dart';
import 'package:fortune/presentation/login/bloc/login.dart';
import 'package:fortune/presentation/mypage/my_page.dart';
import 'package:fortune/presentation/support/faqs/faqs_page.dart';
import 'package:fortune/presentation/support/notices/notices_page.dart';
import 'package:fortune/presentation/support/privacypolicy/privacy_policy_page.dart';
import 'package:fortune/presentation/termsdetail/terms_detail_page.dart';

import 'presentation-web/main/web_main_page.dart';
import 'presentation/ingredientaction/ingredient_action_page.dart';
import 'presentation/login/login_page.dart';
import 'presentation/main/main_ext.dart';
import 'presentation/main/main_page.dart';
import 'presentation/missiondetail/mission_detail_page.dart';
import 'presentation/nickname/nick_name_page.dart';
import 'presentation/obtainhistory/obtain_history_page.dart';
import 'presentation/onboarding/on_boarding_page.dart';
import 'presentation/permission/require_permission_page.dart';

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

  static var webMainHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const WebMainPage();
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
        } else if (kIsWeb) {
          return LoginUserState.web;
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

  static var myPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const MyPage();
    },
  );

  static var faqsHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const FaqPage();
    },
  );

  static var noticesHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const NoticesPage();
    },
  );

  static var gradeGuideHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const GradeGuidePage();
    },
  );

  static var nickNameHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const NickNamePage();
    },
  );

  static var countryCodeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as CountryInfoEntity?;
      return args != null ? CountryCodePage(args) : null;
    },
  );

  static var alarmRewardHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as int?;
      return args != null ? AlarmRewardPage(args) : null;
    },
  );

  static var privacyPolicyHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const PrivacyPolicyPage();
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

      /// 웹 메인.
      ..define(
        Routes.webMainRoute,
        handler: webMainHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 개인정보처리방침.
      ..define(
        Routes.privacyPolicyRoutes,
        handler: privacyPolicyHandler,
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

      /// 마이페이지.
      ..define(
        Routes.myPageRoute,
        handler: myPageHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 약관 상세.
      ..define(
        "${Routes.termsDetailRoute}/:$termsParam",
        handler: termsDetailHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 자주 묻는 질문.
      ..define(
        Routes.faqsRoute,
        handler: faqsHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 국가 코드.
      ..define(
        Routes.countryCodeRoute,
        handler: countryCodeHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 공지사항.
      ..define(
        Routes.noticesRoutes,
        handler: noticesHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 등급가이드.
      ..define(
        Routes.gradeGuideRoute,
        handler: gradeGuideHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 닉네임.
      ..define(
        Routes.nickNameRoute,
        handler: nickNameHandler,
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
  static const String webMainRoute = 'webMain';
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
  static const String gradeGuideRoute = 'gradeGuide';
  static const String countryCodeRoute = 'countryCode';
  static const String myPageRoute = 'myPage';
  static const String faqsRoute = 'faqs';
  static const String nickNameRoute = 'nickName';
  static const String noticesRoutes = 'notices';
  static const String privacyPolicyRoutes = 'privacyPolicy';
}
