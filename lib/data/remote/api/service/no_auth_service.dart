import 'package:chopper/chopper.dart';
import 'package:fortune/data/remote/request/request_email_verify_code.dart';
import 'package:fortune/data/remote/request/request_token_refresh.dart';
import 'package:fortune/data/remote/request/request_user_register.dart';
import 'package:fortune/data/remote/request/request_verify_email.dart';

part 'no_auth_service.chopper.dart';

@ChopperApi(baseUrl: "api/v1/noauth/")
abstract class NoAuthService extends ChopperService {
  static NoAuthService create([ChopperClient? client]) => _$NoAuthService(client);

  @Post(path: 'auth/email/code', optionalBody: true)
  Future<Response> requestEmailVerifyCode(@Body() RequestEmailVerifyCode request);

  @Post(path: 'auth/email', optionalBody: true)
  Future<Response> verifyEmail(@Body() RequestVerifyEmail request);

  @Post(path: 'auth/token/refresh')
  Future<Response> refreshToken(@Body() RequestTokenRefresh token);

  @Post(path: 'users/users/register')
  Future<Response> register(@Body() RequestUserRegister request);
}
