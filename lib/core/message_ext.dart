import 'package:easy_localization/easy_localization.dart';

abstract class FortuneTr {
  static String msgRequireMarkerObtainDistance(String args) => tr('msgRequireMarkerObtainDistance', args: [args]);

  static String msgRequestSmsVerifyCode(
    String minute,
    String second,
  ) =>
      tr('msgRequestSmsVerifyCode', args: [minute, second]);

  static String requireMoreTicket(String ticket) => tr('requireMoreTicket', args: [ticket]);

  static String msgObtainMarkerSuccess(String marker) => tr('msgObtainMarkerSuccess', args: [marker]);

  static String msgConsumeCoinToGetMarker(String ticket) => tr('msgConsumeCoinToGetMarker', args: [ticket]);

  static String msgCollectingMarker(String marker) => tr('msgCollectingMarker', args: [marker]);

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
  static final countryCode = tr('countryCode');
  static final save = tr('save');
  static final phoneNumber = tr('phoneNumber');
  static final logout = tr('logout');
  static final withdrawal = tr('withdrawal');
  static final myInfoModify = tr('myInfoModify');
  static final nickname = tr('nickname');
  static final faq = tr('faq');
  static final notice = tr('notice');
  static final pushAlarm = tr('pushAlarm');
  static final gradeGuide = tr('gradeGuide');
  static final msgUnableToLoadMissionCard = tr('msgUnableToLoadMissionCard');
  static final myBag = tr('myBag');
  static final msgNumberItems = tr('msgNumberItems');
  static final msgUseNextTime = tr('msgUseNextTime');
  static final msgRevokeWithdrawal = tr('msgRevokeWithdrawal');
  static final msgAlreadyWithdrawn = tr('msgAlreadyWithdrawn');
  static final msgMissionCompleted = tr('msgMissionCompleted');
  static final msgPaymentDelay = tr('msgPaymentDelay');
  static final msgConfirmWithdrawal = tr('msgConfirmWithdrawal');
  static final msgWithdrawalWarning = tr('msgWithdrawalWarning');
  static final msgWithdrawal = tr('msgWithdrawal');
  static final msgConfirmLogout = tr('msgConfirmLogout');
  static final msgVerifyYourself = tr('msgVerifyYourself');
  static final msgLoadingLocation = tr('msgLoadingLocation');
  static final msgAcquired = tr('msgAcquired');
  static final msgNoMissionCompletion = tr('msgNoMissionCompletion');
  static final msgHelpedBy = tr('msgHelpedBy');
  static final msgAvailableMissions = tr('msgAvailableMissions');
  static final msgMissionReward = tr('msgMissionReward');
  static final msgGradeInfo = tr('msgGradeInfo');
  static final msgRewardInProgress = tr('msgRewardInProgress');
  static final msgGradeChangeNotice = tr('msgGradeChangeNotice');
  static final msgCurrentGradePrefix = tr('msgCurrentGradePrefix');
  static final msgCurrentGradeSuffix = tr('msgCurrentGradeSuffix');
  static final msgRewardPreparation = tr('msgRewardPreparation');
  static final msgUntilNextLevel = tr('msgUntilNextLevel');
  static final msgNumberPrefix = tr('msgNumberPrefix');
  static final msgMarkerRequirement = tr('msgMarkerRequirement');
  static final msgTicketUpdateFailed = tr('msgTicketUpdateFailed');
  static final msgNicknameExists = tr('msgNicknameExists');
  static final msgVerifyCode = tr('msgVerifyCode');
  static final msgAcquireCoin = tr('msgAcquireCoin');
  static final msgRewardExhausted = tr('msgRewardExhausted');
  static final msgRemainingReward = tr('msgRemainingReward');
  static final msgExchange = tr('msgExchange');
  static final msgRewardRedemptionNotice = tr('msgRewardRedemptionNotice');
  static final msgCongratsMissionCompleted = tr('msgCongratsMissionCompleted');
  static final msgLevelUpHeadings = tr('msgLevelUpHeadings');
  static final msgLevelUpContents = tr('msgLevelUpContents');
  static final msgRelayMissionHeadings = tr('msgRelayMissionHeadings');
  static final msgRelayMissionContents = tr('msgRelayMissionContents');

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
