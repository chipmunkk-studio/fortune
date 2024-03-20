import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/api/service/normal_auth_service.dart';
import 'package:fortune/data/remote/request/request_email_verify_code.dart';
import 'package:fortune/data/remote/response/request_email_verify_code_response.dart';

abstract class AuthNormalDataSource {
  Future<RequestEmailVerifyCodeResponse> requestEmailVerifyCode(RequestEmailVerifyCode request);
}

class AuthNormalDataSourceImpl extends AuthNormalDataSource {
  final NormalAuthService normalAuthService;

  AuthNormalDataSourceImpl({
    required this.normalAuthService,
  });

  @override
  Future<RequestEmailVerifyCodeResponse> requestEmailVerifyCode(RequestEmailVerifyCode request) async {
    return await normalAuthService
        .requestEmailVerifyCode(
          request,
        )
        .then(
          (value) => value.toResponseData(),
        );
  }
}
