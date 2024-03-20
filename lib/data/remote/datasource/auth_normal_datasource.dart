import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/api/service/normal_auth_service.dart';
import 'package:fortune/data/remote/request/request_email_verify_code.dart';

abstract class AuthNormalDataSource {
  Future<void> requestEmailVerifyCode(RequestEmailVerifyCode request);
}

class AuthNormalDataSourceImpl extends AuthNormalDataSource {
  final NormalAuthService normalAuthService;

  AuthNormalDataSourceImpl(this.normalAuthService);

  @override
  Future<void> requestEmailVerifyCode(RequestEmailVerifyCode request) async {
    await normalAuthService.requestEmailVerifyCode(request).then((value) => value.toResponseData());
  }
}
