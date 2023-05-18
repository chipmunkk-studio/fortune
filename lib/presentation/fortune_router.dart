import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'gradeguide/grade_guide_page.dart';
import 'login/countrycode/country_code_page.dart';
import 'login/phonenumber/phone_number_page.dart';
import 'login/smsverify/sms_verify_page.dart';
import 'main/main_page.dart';
import 'markerhistory/marker_history_page.dart';
import 'markerobtain/marker_obtain_page.dart';
import 'mypage/my_page.dart';
import 'onboarding/on_boarding_page.dart';
import 'rewarddetail/reward_detail_page.dart';
import 'rewardlist/reward_list_page.dart';
import 'signup/complete/sign_up_complete.dart';
import 'signup/nickname/enter_nickname_page.dart';
import 'signup/profileimage/enter_profile_image_page.dart';
import 'store/store_page.dart';
import 'support/announcement/announcement_page.dart';
import 'support/faq/faq_page.dart';
import 'usagehistory/fortune/fortune_history_page.dart';
import 'usagehistory/money/money_history_page.dart';
import 'usagehistory/ticket/ticket_history_page.dart';

class FortuneRouter {
  late final FluroRouter router;

  static var mainHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      String? landingRoute = params[Routes.paramLandingPage]?.first;
      return MainPage(landingRoute);
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

  static var rewardListHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const RewardListPage();
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

  static var rewardDetailHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as int?;
      return args != null ? RewardDetailPage(args) : null;
    },
  );

  static var gradeGuideHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const GradeGuidePage();
    },
  );

  static var ticketHistoryHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const TicketHistoryPage();
    },
  );

  static var moneyHistoryHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const MoneyHistoryPage();
    },
  );

  static var fortuneHistoryHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const FortuneHistoryPage();
    },
  );

  static var announcementHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const AnnouncementPage();
    },
  );

  static var questionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const FaqPage();
    },
  );

  static var markerObtainAnimationHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as MarkerObtainArgs?;
      final markerInfo = args?.markerInfo;
      return markerInfo != null ? MarkerObtainPage(markerInfo) : null;
    },
  );

  void init() {
    router = FluroRouter()

      /// 온보딩.
      ..define(
        Routes.onBoardingRoute,
        handler: onBoardingHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 메인 > 랜딩 페이지가 있는 경우.
      ..define(
        "${Routes.mainRoute}/:${Routes.paramLandingPage}",
        handler: mainHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 메인.
      ..define(
        Routes.mainRoute,
        handler: mainHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 회원가입/로그인.
      ..define(
        Routes.phoneNumberRoute,
        handler: phoneNumberHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 국가코드
      ..define(
        Routes.countryCodeRoute,
        handler: countryCodeHandler,
        transitionType: TransitionType.cupertino,
      )

      /// SMS 인증.
      ..define(
        Routes.smsCertifyRoute,
        handler: smsCertifyHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 닉네임 입력.
      ..define(
        Routes.putNickNameRoute,
        handler: putNickNameHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 프로필 이미지 등록.
      ..define(
        Routes.enterProfileImageRoute,
        handler: enterProfileImageHandler,
        transitionType: TransitionType.cupertino,
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
        transitionType: TransitionType.cupertino,
      )

      /// 스탬프 교환소.
      ..define(
        Routes.rewardListRoute,
        handler: rewardListHandler,
        transitionType: TransitionType.cupertino,
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
        transitionType: TransitionType.cupertino,
      )

      /// 상품 상세.
      ..define(
        Routes.rewardDetailRoute,
        handler: rewardDetailHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 등급 안내.
      ..define(
        Routes.gradeGuideRoute,
        handler: gradeGuideHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 티켓 사용 내역.
      ..define(
        Routes.ticketHistoryRoute,
        handler: ticketHistoryHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 금화 사용 내역.
      ..define(
        Routes.moneyHistoryRoute,
        handler: moneyHistoryHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 포춘 사용 내역.
      ..define(
        Routes.fortuneHistoryRoute,
        handler: fortuneHistoryHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 공지사항.
      ..define(
        Routes.announcementRoute,
        handler: announcementHandler,
        transitionType: TransitionType.cupertino,
      )

      /// 자주 묻는 질문.
      ..define(
        Routes.faqRoute,
        handler: questionHandler,
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
  static const String paramLandingPage = "paramLandingPage";
  static const String mainRoute = 'main';
  static const String onBoardingRoute = 'onBoarding';
  static const String phoneNumberRoute = 'phoneNumber';
  static const String countryCodeRoute = 'countryCode';
  static const String smsCertifyRoute = 'smsCertify';
  static const String putNickNameRoute = 'putNickName';
  static const String markerHistoryRoute = 'markerHistory';
  static const String enterProfileImageRoute = 'enterProfileImage';
  static const String signUpCompleteRoute = 'signUpComplete';
  static const String rewardListRoute = 'rewardList';
  static const String markerObtainAnimationRoute = 'markerObtainAnimation';
  static const String storeRoute = 'store';
  static const String myPageRoute = 'myPage';
  static const String rewardDetailRoute = 'product';
  static const String gradeGuideRoute = 'gradeGuide';
  static const String ticketHistoryRoute = 'ticketHistory';
  static const String moneyHistoryRoute = 'moneyHistory';
  static const String fortuneHistoryRoute = 'fortuneHistory';
  static const String announcementRoute = 'announcement';
  static const String faqRoute = 'faq';
}
