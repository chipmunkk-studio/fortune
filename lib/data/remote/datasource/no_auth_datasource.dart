import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/api/service/no_auth_service.dart';
import 'package:fortune/data/remote/request/request_email_verify_code.dart';
import 'package:fortune/data/remote/request/request_user_register.dart';
import 'package:fortune/data/remote/request/request_verify_email.dart';
import 'package:fortune/data/remote/response/email_verify_code_response.dart';
import 'package:fortune/data/remote/response/user_token_response.dart';
import 'package:fortune/data/remote/response/verify_email_response.dart';
import 'package:fortune/domain/entity/email_verify_code_entity.dart';
import 'package:fortune/domain/entity/user_token_entity.dart';
import 'package:fortune/domain/entity/verify_email_entity.dart';

abstract class NoAuthDataSource {
  Future<EmailVerifyCodeEntity> requestEmailVerifyCode(RequestEmailVerifyCode request);

  Future<VerifyEmailEntity> verifyEmail(RequestVerifyEmail request);

  Future<UserTokenEntity> register(RequestUserRegister request);
}

class NoAuthDataSourceImpl extends NoAuthDataSource {
  final NoAuthService normalAuthService;

  NoAuthDataSourceImpl({
    required this.normalAuthService,
  });

  @override
  Future<EmailVerifyCodeEntity> requestEmailVerifyCode(RequestEmailVerifyCode request) async {
    return await normalAuthService.requestEmailVerifyCode(request).then(
          (value) => EmailVerifyCodeResponse.fromJson(
            value.toResponseData(),
          ),
        );
  }

  @override
  Future<VerifyEmailEntity> verifyEmail(RequestVerifyEmail request) async {
    return await normalAuthService.verifyEmail(request).then(
          (value) => VerifyEmailResponse.fromJson(
            value.toResponseData(),
          ),
        );
  }

  @override
  Future<UserTokenEntity> register(RequestUserRegister request) async {
    return await normalAuthService.register(request).then(
          (value) => UserTokenResponse.fromJson(
            value.toResponseData(),
          ),
        );
  }
}
