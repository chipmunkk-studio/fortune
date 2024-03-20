import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/api/service/normal_auth_service.dart';
import 'package:fortune/data/remote/request/request_email_verify_code.dart';
import 'package:fortune/data/remote/request/request_verify_email.dart';
import 'package:fortune/data/remote/response/email_verify_code_response.dart';
import 'package:fortune/data/remote/response/verify_email_response.dart';

abstract class NoAuthDataSource {
  Future<EmailVerifyCodeResponse> requestEmailVerifyCode(RequestEmailVerifyCode request);

  Future<VerifyEmailResponse> verifyEmail(RequestVerifyEmail request);
}

class AuthNormalDataSourceImpl extends NoAuthDataSource {
  final NoAuthService normalAuthService;

  AuthNormalDataSourceImpl({
    required this.normalAuthService,
  });

  @override
  Future<EmailVerifyCodeResponse> requestEmailVerifyCode(RequestEmailVerifyCode request) async {
    return await normalAuthService
        .requestEmailVerifyCode(
          request,
        )
        .then(
          (value) => EmailVerifyCodeResponse.fromJson(
            value.toResponseData(),
          ),
        );
  }

  @override
  Future<VerifyEmailResponse> verifyEmail(RequestVerifyEmail request) async {
    return await normalAuthService
        .verifyEmail(
          request,
        )
        .then(
          (value) => VerifyEmailResponse.fromJson(
            value.toResponseData(),
          ),
        );
  }
}
