import 'package:foresh_flutter/domain/repositories/auth_normal_remote_repository.dart';

import '../../core/util/usecase.dart';

class ObtainSmsVerifyCodeUseCase implements UseCase1<void, RequestSmsVerifyCodeParams> {
  final AuthNormalRemoteRepository repository;

  ObtainSmsVerifyCodeUseCase(this.repository);

  @override
  Future<FortuneResult<void>> call(RequestSmsVerifyCodeParams params) async {
    return await repository.requestSmsVerifyCode(params);
  }
}

class RequestSmsVerifyCodeParams {
  String phoneNumber;
  String countryCode;

  RequestSmsVerifyCodeParams({
    required this.phoneNumber,
    required this.countryCode,
  });
}
