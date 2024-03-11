import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fortune/presentation-v2/login/bloc/login_state.dart';
import 'package:fortune/presentation-v2/login/login_page.dart';
import 'package:fortune/presentation-v2/onboarding/on_boarding_page.dart';
import 'package:fortune/presentation-v2/permission/require_permission_page.dart';
import 'package:fortune/presentation-v2/termsdetail/terms_detail_page.dart';

class FortuneAppRouter {
  late final FluroRouter router;

  static const String routeParam = "routeParam";

  // static var mainHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     final data = params[routeParam]?.first.toString() ?? '';
  //     if (data.isNotEmpty) {
  //       Map<String, dynamic> decodedMap = jsonDecode(params[routeParam]?.first ?? '');
  //       FortuneNotificationEntity notification = FortuneNotificationResponse.fromJson(decodedMap);
  //       return MainPage(notification);
  //     } else {
  //       return const MainPage(null);
  //     }
  //   },
  // );

  static var permissionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const RequestPermissionPage();
    },
  );

  // static var missionDetailNormalHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     final args = context?.settings?.arguments as MissionViewEntity?;
  //     return args != null ? MissionDetailPage(args) : null;
  //   },
  // );

  static var onBoardingHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const OnBoardingPage();
    },
  );

  // static var myMissionsHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     return const MyMissionsPage();
  //   },
  // );

  // static var rankingHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     return const RankingPage();
  //   },
  // );

  static var termsDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      int? data;
      var paramValue = params[routeParam]?.first;
      if (paramValue != null) {
        data = int.tryParse(paramValue);
      }
      return data != null ? TermsDetailPage(data) : null;
    },
  );

  // static var fortuneWebViewHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     final args = context?.settings?.arguments as FortuneWebViewArgs?;
  //     return args != null ? FortuneWebViewPage(args) : null;
  //   },
  // );

  // static var ingredientActionHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     final args = context?.settings?.arguments as IngredientActionParam?;
  //     return args != null ? IngredientActionPage(args) : null;
  //   },
  // );

  // static var giftboxActionHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     final args = context?.settings?.arguments as GiftboxActionParam?;
  //     return args != null ? GiftboxActionPage(args) : null;
  //   },
  // );

  static var loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      String sessionsState = params[routeParam]?.first ?? LoginUserState.none.name;
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

  // static var obtainHistoryHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     final args = context?.settings?.arguments as MainLandingArgs?;
  //     return ObtainHistoryPage(searchText: args != null ? args.text : '');
  //   },
  // );

  // static var alarmFeedHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     return const AlarmFeedPage();
  //   },
  // );

  // static var myPageHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     return const MyPage();
  //   },
  // );

  // static var faqsHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     return const FaqPage();
  //   },
  // );

  // static var noticesHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     return const NoticesPage();
  //   },
  // );

  // static var gradeGuideHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     return const GradeGuidePage();
  //   },
  // );

  // static var nickNameHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     return const NickNamePage();
  //   },
  // );

  // static var countryCodeHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     final args = context?.settings?.arguments as CountryInfoEntity?;
  //     return args != null ? CountryCodePage(args) : null;
  //   },
  // );

  // static var privacyPolicyHandler = Handler(
  //   handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
  //     return const PrivacyPolicyPage();
  //   },
  // );

  void init() {
    router = FluroRouter()

      /// 로그인.
      ..define(
        AppRoutes.loginRoute,
        handler: loginHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 로그인 > 세션 만료 인 경우
      ..define(
        "${AppRoutes.loginRoute}/:$routeParam",
        handler: loginHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 메인.
      // ..define(
      //   AppRoutes.mainRoute,
      //   handler: mainHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 개인정보처리방침.
      // ..define(
      //   AppRoutes.privacyPolicyRoutes,
      //   handler: privacyPolicyHandler,
      //   transitionType: TransitionType.cupertino,
      // )
      //
      // /// 메인. > 노티피케이션
      // ..define(
      //   "${AppRoutes.mainRoute}/:$routeParam",
      //   handler: mainHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 권한 요청.
      ..define(
        AppRoutes.requestPermissionRoute,
        handler: permissionHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 온보딩.
      ..define(
        AppRoutes.onBoardingRoute,
        handler: onBoardingHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 재료 획득 액션.
      // ..define(
      //   AppRoutes.ingredientActionRoute,
      //   opaque: false,
      //   handler: ingredientActionHandler,
      //   transitionType: TransitionType.fadeIn,
      // )

      /// 노말 미션 상세.
      // ..define(
      //   AppRoutes.missionDetailNormalRoute,
      //   handler: missionDetailNormalHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 알림 피드.
      // ..define(
      //   AppRoutes.alarmFeedRoute,
      //   handler: alarmFeedHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 마이페이지.
      // ..define(
      //   AppRoutes.myPageRoute,
      //   handler: myPageHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 약관 상세.
      ..define(
        "${AppRoutes.termsDetailRoute}/:$routeParam",
        handler: termsDetailHandler,
        transitionType: TransitionType.cupertino,
      );

      /// 자주 묻는 질문.
      // ..define(
      //   AppRoutes.faqsRoute,
      //   handler: faqsHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 국가 코드.
      // ..define(
      //   AppRoutes.countryCodeRoute,
      //   handler: countryCodeHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 공지사항.
      // ..define(
      //   AppRoutes.noticesRoutes,
      //   handler: noticesHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 등급가이드.
      // ..define(
      //   AppRoutes.gradeGuideRoute,
      //   handler: gradeGuideHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 닉네임.
      // ..define(
      //   AppRoutes.nickNameRoute,
      //   handler: nickNameHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 내 미션 완료 목록.
      // ..define(
      //   AppRoutes.myMissionsRoutes,
      //   handler: myMissionsHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 랭킹.
      // ..define(
      //   AppRoutes.rankingRoutes,
      //   handler: rankingHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 랜덤박스.
      // ..define(
      //   AppRoutes.giftBoxActionRoute,
      //   handler: giftboxActionHandler,
      //   transitionType: TransitionType.fadeIn,
      // )

      /// 웹뷰.
      // ..define(
      //   AppRoutes.fortuneWebViewRoutes,
      //   handler: fortuneWebViewHandler,
      //   transitionType: TransitionType.cupertino,
      // )

      /// 마커 히스토리.
      // ..define(
      //   AppRoutes.obtainHistoryRoute,
      //   handler: obtainHistoryHandler,
      //   transitionType: TransitionType.cupertino,
      // );
  }
}

class AppRoutes {
  static const String mainRoute = 'main';
  static const String loginRoute = 'login';
  static const String onBoardingRoute = 'onBoarding';
  static const String requestPermissionRoute = 'requestPermission';
  static const String obtainHistoryRoute = 'obtainHistory';
  static const String alarmFeedRoute = 'alarmFeed';
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
  static const String giftBoxActionRoute = 'giftBox';
  static const String privacyPolicyRoutes = 'privacyPolicy';
  static const String myMissionsRoutes = 'myMissions';
  static const String rankingRoutes = 'ranking';
  static const String writePostRoutes = 'writePost'; // todo 삭제해야됨.
  static const String viewPostRoutes = 'viewPost'; // todo 삭제해야됨.
  static const String fortuneWebViewRoutes = 'fortuneWebView';
}
