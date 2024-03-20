import 'package:chopper/chopper.dart';
import 'package:fortune/data/remote/request/request_email_verify_code.dart';
import 'package:fortune/data/remote/request/request_token_refresh.dart';
import 'package:fortune/data/remote/request/request_verify_email.dart';

part 'normal_auth_service.chopper.dart';

@ChopperApi(baseUrl: "api/v1/auth/")
abstract class NoAuthService extends ChopperService {
  static NoAuthService create([ChopperClient? client]) => _$NoAuthService(client);

  @Post(path: 'email/code', optionalBody: true)
  Future<Response> requestEmailVerifyCode(@Body() RequestEmailVerifyCode request);

  @Post(path: 'email', optionalBody: true)
  Future<Response> verifyEmail(@Body() RequestVerifyEmail request);

  @Post(path: 'token/refresh')
  Future<Response> refreshToken(@Body() RequestTokenRefresh token);
}
