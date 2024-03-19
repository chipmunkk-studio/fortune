import 'package:chopper/chopper.dart';
import 'package:fortune/data/remote/api/request/request_email_verify_code.dart';

import '../../request/request_confirm_sms_verify_code.dart';

part 'normal_auth_service.chopper.dart';

@ChopperApi(baseUrl: "api/v1/auth/")
abstract class NormalAuthService extends ChopperService {
  static NormalAuthService create([ChopperClient? client]) => _$NormalAuthService(client);

  @Post(path: 'email', optionalBody: true)
  Future<Response> requestEmailVerifyCode(@Body() RequestEmailVerifyCode request);

  @Post(path: 'number/sms-verify', optionalBody: true)
  Future<Response> confirmSmsVerifyCode(@Body() RequestConfirmSmsVerifyCode request);
}
