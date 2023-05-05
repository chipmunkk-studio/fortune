import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'exchange/exchange_page.dart';
import 'gradeguide/grade_guide_page.dart';
import 'history/marker_history_page.dart';
import 'login/countrycode/country_code_page.dart';
import 'login/phonenumber/phone_number_page.dart';
import 'login/smsverify/sms_verify_page.dart';
import 'main/main_page.dart';
import 'markerobtain/marker_obtain_page.dart';
import 'mypage/my_page.dart';
import 'onboarding/on_boarding_page.dart';
import 'product/product_page.dart';
import 'signup/complete/sign_up_complete.dart';
import 'signup/nickname/enter_nickname_page.dart';
import 'signup/profileimage/enter_profile_image_page.dart';
import 'store/store_page.dart';

class FortuneRouter {
  late final FluroRouter router;

  static var mainHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const MainPage();
    },
  );

  static var onBoardingHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return OnBoardingPage();
    },
  );

  static var phoneNumberHandler = Handler(
    handlerFunc: (context, params) {
      final args = context?.settings?.arguments as CountryCodeArgs?;
      final countryCode = args?.countryCode;
      final countryName = args?.countryName;
      return PhoneNumberPage(
        countryCode: countryCode,
        countryName: countryName,
      );
    },
  );

  static var countryCodeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as CountryCodeArgs?;
      final countryCode = args?.countryCode;
      final countryName = args?.countryName;
      return CountryCodePage(
        countryCode: countryCode,
        countryName: countryName,
      );
    },
  );

  static var smsCertifyHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as SmsVerifyArgs?;
      final phoneNumber = args?.phoneNumber ?? "";
      final countryCode = args?.countryCode ?? "";
      return SmsVerifyPage(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );
    },
  );

  static var putNickNameHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      /// todo 이부분을 신중하게 고민해봐됨.
      /// 블럭을 과연 싱글턴으로 사용해도 이슈가 없는 건지?
      /// ActivityViewModel이 없다면 어떻게 구현하는게 좋은건지?! 잊지말아야함.
      final args = context?.settings?.arguments as SmsVerifyArgs?;
      final phoneNumber = args?.phoneNumber ?? "";
      final countryCode = args?.countryCode ?? "";
      return EnterNickNamePage(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
      );
    },
  );

  static var enterProfileImageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const EnterProfileImagePage();
    },
  );

  static var signUpCompleteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const SignUpCompletePage();
    },
  );

  static var markerHistoryHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const MarkerHistoryPage();
    },
  );

  static var exchangeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const ExchangePage();
    },
  );

  static var storeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const StorePage();
    },
  );

  static var myPageHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const MyPage();
    },
  );

  static var productHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const ProductPage();
    },
  );

  static var gradeGuideHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const GradeGuidePage();
    },
  );

  static var markerObtainAnimationHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as MarkerObtainArgs?;
      final grade = args?.grade ?? -1;
      final message = args?.message ?? "";
      return MarkerObtainPage(
        grade: grade,
        message: message,
      );
    },
  );

  void init() {
    router = FluroRouter()

      /// 온보딩.
      ..define(
        Routes.onBoardingRoute,
        handler: onBoardingHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 메인.
      ..define(
        Routes.mainRoute,
        handler: mainHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 회원가입/로그인.
      ..define(
        Routes.phoneNumberRoute,
        handler: phoneNumberHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 국가코드
      ..define(
        Routes.countryCodeRoute,
        handler: countryCodeHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// SMS 인증.
      ..define(
        Routes.smsCertifyRoute,
        handler: smsCertifyHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 닉네임 입력.
      ..define(
        Routes.putNickNameRoute,
        handler: putNickNameHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 프로필 이미지 등록.
      ..define(
        Routes.enterProfileImageRoute,
        handler: enterProfileImageHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 회원가입 완료.
      ..define(
        Routes.signUpCompleteRoute,
        handler: signUpCompleteHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 마커 히스토리.
      ..define(
        Routes.markerHistoryRoute,
        handler: markerHistoryHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 스탬프 교환소.
      ..define(
        Routes.exchangeRoute,
        handler: exchangeHandler,
        transitionType: TransitionType.material,
      )

      /// 스토어.
      ..define(
        Routes.storeRoute,
        handler: storeHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 마이페이지.
      ..define(
        Routes.myPageRoute,
        handler: myPageHandler,
        transitionType: TransitionType.material,
      )

      /// 상품 상세.
      ..define(
        Routes.productRoute,
        handler: productHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 등급 안내.
      ..define(
        Routes.gradeGuideRoute,
        handler: gradeGuideHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 마커 획득 시 애니메이션 화면 루트.
      ..define(
        Routes.markerObtainAnimationRoute,
        handler: markerObtainAnimationHandler,
        transitionType: TransitionType.fadeIn,
      );
  }
}

class Routes {
  static const String mainRoute = 'mainRoute';
  static const String onBoardingRoute = 'onBoardingRoute';
  static const String phoneNumberRoute = 'phoneNumberRoute';
  static const String countryCodeRoute = 'countryCodeRoute';
  static const String smsCertifyRoute = 'smsCertifyRoute';
  static const String putNickNameRoute = 'putNickNameRoute';
  static const String markerHistoryRoute = 'markerHistoryRoute';
  static const String enterProfileImageRoute = 'enterProfileImageRoute';
  static const String signUpCompleteRoute = 'signUpCompleteRoute';
  static const String exchangeRoute = 'exchangeRoute';
  static const String markerObtainAnimationRoute = 'markerObtainAnimationRoute';
  static const String storeRoute = 'storeRoute';
  static const String myPageRoute = 'myPageRoute';
  static const String productRoute = 'productRoute';
  static const String gradeGuideRoute = 'gradeGuideRoute';
}
