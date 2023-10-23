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

  static String msgDaysAgo(String day) => tr('msgDaysAgo', args: [day]);

  static String msgHoursAgo(String hour) => tr('msgHoursAgo', args: [hour]);

  static String msgCenterLevel(String hour) => tr('msgCenterLevel', args: [hour]);

  static String msgMinutesAgo(String minute) => tr('msgMinutesAgo', args: [minute]);

  static String msgJustNow() => tr('msgJustNow');

  static String msgLevelUpContents(String level) => tr('msgLevelUpContents', args: [level]);

  static String msgAchievedGrade(String grade) => tr('msgAchievedGrade', args: [grade]);

  static String msgAcquiredMarker(String marker) => tr('msgAcquiredMarker', args: [marker]);

  static String msgItemCount(String count) => tr('msgItemCount', args: [count]);

  static String msgAcquireMarker(
    String nickname,
    String location,
    String ingredientName,
  ) =>
      tr('msgAcquireMarker', args: [nickname, location, ingredientName]);

  // 사용자
  static final msgNotExistUser = tr('msgNotExistUser');
  static final msgNotExistTerms = tr('msgNotExistTerms');
  static final msgUpdateUserInfo = tr('msgUpdateUserInfo');
  static final msgNotUpdateUser = tr('msgNotUpdateUser');
  static final msgRenewAuthInfo = tr('msgRenewAuthInfo');
  static final msgCoinReward = tr('msgCoinReward');
  static final msgUpdateMarkerInfo = tr('msgUpdateMarkerInfo');

  static final msgWelcome = tr('msgWelcome');
  static final msgFortuneCookieReward = tr('msgFortuneCookieReward');

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
  static final email = tr('email');
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
  static final msgMissionHistory = tr('msgMissionHistory');
  static final msgNoCompletedMissions = tr('msgNoCompletedMissions');
  static final msgCompletedMissions = tr('msgCompletedMissions');
  static final msgRevokeWithdrawal = tr('msgRevokeWithdrawal');
  static final msgHallOfFame = tr('msgHallOfFame');
  static final msgRetryLater = tr('msgRetryLater');
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
  static final msgNoNotifications = tr('msgNoNotifications');
  static final msgRewardCompleted = tr('msgRewardCompleted');
  static final msgGradeInfo = tr('msgGradeInfo');
  static final msgRewardInProgress = tr('msgRewardInProgress');
  static final msgCollectWithCoin = tr('msgCollectWithCoin');
  static final msgNewGradeReached = tr('msgNewGradeReached');
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
  static final msgReceiveRewardCompleted = tr('msgReceiveRewardCompleted');
  static final msgRewardExhausted = tr('msgRewardExhausted');
  static final msgRemainingReward = tr('msgRemainingReward');
  static final msgUnknownUser = tr('msgUnknownUser');
  static final msgNoWebSupport = tr('msgNoWebSupport');
  static final msgExchange = tr('msgExchange');
  static final msgRewardRedemptionNotice = tr('msgRewardRedemptionNotice');
  static final msgCongratsMissionCompleted = tr('msgCongratsMissionCompleted');
  static final msgLevelUpHeadings = tr('msgLevelUpHeadings');
  static final msgRelayMissionHeadings = tr('msgRelayMissionHeadings');
  static final msgNoReward = tr('msgNoReward');
  static final msgRelayMissionContents = tr('msgRelayMissionContents');
  static final msgPrivacyPolicy = tr('msgPrivacyPolicy');
  static final msgMissionEarlyEnd = tr('msgMissionEarlyEnd');
  static final msgUnknownLocation = tr('msgUnknownLocation');
  static final msgUnfairParticipation = tr('msgUnfairParticipation');
  static final msgMissionGuide = tr('msgMissionGuide');
  static final msgRewardGuide = tr('msgRewardGuide');
  static final msgCaution = tr('msgCaution');
  static final msgNoMarkers = tr('msgNoMarkers');
  static final msgUnknownError = tr('msgUnknownError');

  // 온보딩
  static final msgOnboardingTitle1 = tr('msgOnboardingTitle1');
  static final msgOnboardingTitle2 = tr('msgOnboardingTitle2');
  static final msgReceiveReward = tr('msgReceiveReward');
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
  static final msgInputEmail = tr('msgInputEmail');
  static final msgInputEmailNotValid = tr('msgInputEmailNotValid');
  static final msgInputNickNameNotValid = tr('msgInputNickNameNotValid');
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
