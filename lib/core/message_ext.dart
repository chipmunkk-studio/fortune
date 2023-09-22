import 'package:easy_localization/easy_localization.dart';

abstract class FortuneTr {
  static String msgRequireMarkerObtainDistance(String args) {
    return tr('msgRequireMarkerObtainDistance', args: [args]);
  }

  static String msgRequestSmsVerifyCode(
    String minute,
    String second,
  ) {
    return tr('msgRequestSmsVerifyCode', args: [minute, second]);
  }

  static String requireMoreTicket(
    String ticket,
  ) {
    return tr('requireMoreTicket', args: [ticket]);
  }

  static String msgConsumeCoinToGetMarker(
    String ticket,
  ) {
    return tr('msgConsumeCoinToGetMarker', args: [ticket]);
  }

  // 사용자
  static final notExistUser = tr('msgNotExistUser');
  static final notExistTerms = tr('msgNotExistTerms');
  static final notFoundUser = tr('msgNotFoundUser');
  static final notUpdateUser = tr('msgNotUpdateUser');
  static final renewAuthInfo = tr('msgRenewAuthInfo');

  static final start = tr('start');
  static final next = tr('next');
  static final move = tr('move');
  static final modify = tr('modify');
  static final confirm = tr('confirm');
  static final cancel = tr('cancel');
  static final noHistory = tr('noHistory');
  static final myInfo = tr('myInfo');
  static final faq = tr('faq');
  static final notice = tr('notice');
  static final pushAlarm = tr('pushAlarm');
  static final gradeGuide = tr('gradeGuide');

  // 온보딩
  static final msgOnboardingTitle1 = tr('msgOnboardingTitle1');
  static final msgOnboardingTitle2 = tr('msgOnboardingTitle2');
  static final msgOnboardingTitle3 = tr('msgOnboardingTitle3');
  static final msgOnboarding1 = tr('msgOnboarding1');
  static final msgOnboarding2 = tr('msgOnboarding2');
  static final msgOnboarding3 = tr('msgOnboarding3');
  static final fortuneTermsOfUse = tr('fortuneTermsOfUse');

  // 권한
  static final msgRequirePermissionPhone = tr('msgRequirePermissionPhone');
  static final msgRequirePermissionLocation = tr('msgRequirePermissionLocation');
  static final msgRequirePermissionPhoto = tr('msgRequirePermissionPhoto');
  static final msgRequirePermissionNotice = tr('msgRequirePermissionNotice');
  static final msgRequirePermissionPhoneContent = tr('msgRequirePermissionPhoneContent');
  static final msgRequirePermissionLocationContent = tr('msgRequirePermissionLocationContent');
  static final msgRequirePermissionPhotoContent = tr('msgRequirePermissionPhotoContent');
  static final msgRequirePermissionNoticeContent = tr('msgRequirePermissionNoticeContent');
  static final msgRequirePermissionTitle = tr('msgRequirePermissionTitle');
  static final msgRequirePermissionSubTitle = tr('msgRequirePermissionSubTitle');
  static final msgRequirePermission = tr('msgRequirePermission');
  static final msgRequirePermissionContent = tr('msgRequirePermissionContent');
  static final msgInputPhoneNumber = tr('msgInputPhoneNumber');
  static final msgInputPhoneNumberNotValid = tr('msgInputPhoneNumberNotValid');
  static final msgRequireTermsUse = tr('msgRequireTermsUse');
  static final msgRequireTermsApprove = tr('msgRequireTermsApprove');

  // 히스토리
  static final historyFortuneSpot = tr('historyFortuneSpot');
  static final historyFortuneSpotSearchInput = tr('historyFortuneSpotSearchInput');

  // 인증번호
  static final msgRequireVerifyCodeInput = tr('msgRequireVerifyCodeInput');
  static final msgRequireVerifyCodeReceive = tr('msgRequireVerifyCodeReceive');
  static final msgRequireVerifySixNumber = tr('msgRequireVerifySixNumber');
  static final msgRequireVerifySixNumberContent = tr('msgRequireVerifySixNumberContent');

  // 네트워크 에러
  static final confirmNetworkConnection = tr('msgConfirmNetworkConnection');

  // 메인
  static final msgWatchAd = tr('msgWatchAd');
  static final callMyLocation = tr('callMyLocation');
}
