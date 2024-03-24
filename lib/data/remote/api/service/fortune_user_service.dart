import 'package:chopper/chopper.dart';

part 'fortune_user_service.chopper.dart';

@ChopperApi(baseUrl: "api/v1/users/")
abstract class FortuneUserService extends ChopperService {
  static FortuneUserService create([ChopperClient? client]) => _$FortuneUserService(client);

  /// 사용자 정보.
  @Get(path: 'me')
  Future<Response> me();
}
