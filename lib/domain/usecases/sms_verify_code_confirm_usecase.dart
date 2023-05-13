import 'package:foresh_flutter/domain/entities/sms_verify_result_entity.dart';

import '../../core/util/usecase.dart';
import '../repositories/auth_normal_remote_repository.dart';

class SmsVerifyCodeConfirmUseCase implements UseCase1<SmsVerifyCodeConfirmEntity, RequestConfirmSmsVerifyCodeParams> {
  final AuthNormalRemoteRepository repository;

  SmsVerifyCodeConfirmUseCase(this.repository);

  @override
  Future<FortuneResult<SmsVerifyCodeConfirmEntity>> call(RequestConfirmSmsVerifyCodeParams params) async {
    return await repository.confirmSmsVerifyCode(params);
  }
}

class RequestConfirmSmsVerifyCodeParams {
  final String phoneNumber;
  final String countryCode;
  final int authenticationNumber;
  final String? pushToken;

  RequestConfirmSmsVerifyCodeParams({
    required this.phoneNumber,
    required this.countryCode,
    required this.authenticationNumber,
    required this.pushToken,
  });
}
