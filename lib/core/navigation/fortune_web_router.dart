import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:fortune/presentation-web/login/web_login_page.dart';
import 'package:fortune/presentation-web/retire/web_retire_page.dart';
import 'package:fortune/presentation-web/viewpost/view_post_page.dart';
import 'package:fortune/presentation-web/writepost/write_post.dart';
import 'package:fortune/presentation/support/privacypolicy/privacy_policy_page.dart';
import 'package:fortune/presentation/termsdetail/terms_detail_page.dart';

import '../../presentation-web/main/web_main_page.dart';

class FortuneWebRouter {
  late final FluroRouter router;
  static const String routeParam = "routeParam";

  static Handler webMainHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const WebMainPage();
    },
  );

  static var loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const WebLoginPage();
    },
  );

  static var retireHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const WebRetirePage();
    },
  );

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

  static var privacyPolicyHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const PrivacyPolicyPage();
    },
  );

  static var writePostHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const WritePostPage();
    },
  );

  static var viewPostHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as ViewPostPageArgs?;
      return args != null ? ViewPostPage(args: args) : null;
    },
  );

  void init() {
    router = FluroRouter()

      /// 로그인.
      ..define(
        WebRoutes.loginRoute,
        handler: loginHandler,
        transitionType: TransitionType.fadeIn,
      )
      /// 회원탈퇴
      ..define(
        WebRoutes.retireRoute,
        handler: retireHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 글쓰기.
      ..define(
        WebRoutes.writePostRoute,
        handler: writePostHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 글보기.
      ..define(
        WebRoutes.viewPostRoute,
        handler: viewPostHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 약관상세.
      ..define(
        "${WebRoutes.termsDetailRoute}/:$routeParam",
        handler: termsDetailHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 개인정보처리방침
      ..define(
        WebRoutes.privacyPolicyRoutes,
        handler: privacyPolicyHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 웹 메인.
      ..define(
        WebRoutes.mainRoute,
        handler: webMainHandler,
        transitionType: TransitionType.fadeIn,
      );
  }
}

class WebRoutes {
  static const String mainRoute = 'main';
  static const String exitRoute = 'exit';
  static const String privacyPolicyRoutes = 'privacyPolicy';
  static const String termsDetailRoute = 'termsDetail';
  static const String loginRoute = 'login';
  static const String writePostRoute = 'writePost';
  static const String viewPostRoute = 'viewPost';
  static const String readRoute = 'read';
  static const String retireRoute = 'retire';
}
