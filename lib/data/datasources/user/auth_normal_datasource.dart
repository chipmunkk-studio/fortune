import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/network/api/request/request_confirm_sms_verify_code.dart';
import 'package:foresh_flutter/core/util/logger.dart';

import '../../../core/network/api/request/request_sms_verify_code.dart';
import '../../../core/network/api/service/normal/normal_auth_service.dart';
import '../../../domain/entities/sms_verify_result_entity.dart';
import '../../responses/user/sms_verify_code_confirm_response.dart';

abstract class AuthNormalDataSource {
  Future<void> requestSmsVerifyCode(RequestSmsVerifyCode params);

  Future<SmsVerifyCodeConfirmEntity> confirmSmsVerifyCode(RequestConfirmSmsVerifyCode params);
}

class AuthNormalDataSourceImpl extends AuthNormalDataSource {
  final NormalAuthService authNormalService;

  AuthNormalDataSourceImpl(this.authNormalService);

  @override
  Future<void> requestSmsVerifyCode(RequestSmsVerifyCode params) async {
    final smsVerifyCode = await authNormalService.requestSmsVerifyCode(params).then((value) => value.toResponseData());
    // final countryCodeEntity = CountryCodeListResponse.fromJson(countryCode);
    FortuneLogger.debug("coutryCode: $smsVerifyCode");
  }

  @override
  Future<SmsVerifyCodeConfirmEntity> confirmSmsVerifyCode(RequestConfirmSmsVerifyCode params) async {
    final confirmResult = await authNormalService.confirmSmsVerifyCode(params).then((value) => value.toResponseData());
    final confirmEntity = SmsVerifyCodeConfirmResponse.fromJson(confirmResult);
    return confirmEntity;
  }
}
