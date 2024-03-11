import 'package:chopper/chopper.dart';

import '../../request/request_confirm_sms_verify_code.dart';
import '../../request/request_sms_verify_code.dart';

part 'normal_auth_service.chopper.dart';

@ChopperApi(baseUrl: "/v1/authentication/")
abstract class NormalAuthService extends ChopperService {
  static NormalAuthService create([ChopperClient? client]) => _$NormalAuthService(client);

  @Post(path: 'number/sms-request', optionalBody: true)
  Future<Response> requestSmsVerifyCode(@Body() RequestSmsVerifyCode request);

  @Post(path: 'number/sms-verify', optionalBody: true)
  Future<Response> confirmSmsVerifyCode(@Body() RequestConfirmSmsVerifyCode request);
}
