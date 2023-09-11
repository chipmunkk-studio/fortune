import 'package:easy_localization/easy_localization.dart';

abstract class FortuneTr {
  // 사용자
  static final notExistUser = tr('msg_not_exist_user');
  static final notExistTerms = tr('msg_not_exist_terms');
  static final notFoundUser = tr('msg_not_found_user');
  static final notUpdateUser = tr('msg_not_update_user');
  static final renewAuthInfo = tr('msg_renew_auth_info');

  // 온보딩
  static final start = tr('start');
  static final next = tr('next');
  static final move = tr('move');
  static final msgOnboardingTitle1 = tr('msg_onboarding_title_1');
  static final msgOnboardingTitle2 = tr('msg_onboarding_title_2');
  static final msgOnboardingTitle3 = tr('msg_onboarding_title_3');
  static final msgOnboarding1 = tr('msg_onboarding_1');
  static final msgOnboarding2 = tr('msg_onboarding_2');
  static final msgOnboarding3 = tr('msg_onboarding_3');

  // 권한
  static final msgRequirePermissionPhone = tr('msg_require_permission_phone');
  static final msgRequirePermissionLocation = tr('msg_require_permission_location');
  static final msgRequirePermissionPhoto = tr('msg_require_permission_photo');
  static final msgRequirePermissionNotice = tr('msg_require_permission_notice');
  static final msgRequirePermissionPhoneContent = tr('msg_require_permission_phone_content');
  static final msgRequirePermissionLocationContent = tr('msg_require_permission_location_content');
  static final msgRequirePermissionPhotoContent = tr('msg_require_permission_photo_content');
  static final msgRequirePermissionNoticeContent = tr('msg_require_permission_notice_content');
  static final msgRequirePermissionTitle = tr('msg_require_permission_title');
  static final msgRequirePermissionSubTitle = tr('msg_require_permission_sub_title');
  static final msgRequirePermission = tr('msg_require_permission');
  static final msgRequirePermissionContent = tr('msg_require_permission_content');

  // 네트워크 에러
  static final confirmNetworkConnection = tr('msg_confirm_network_connection');
}
