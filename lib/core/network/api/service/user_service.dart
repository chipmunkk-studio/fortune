import 'package:chopper/chopper.dart';

part 'user_service.chopper.dart';

@ChopperApi(baseUrl: "/v1/user")
abstract class UserService extends ChopperService {
  static UserService create([ChopperClient? client]) => _$UserService(client);

  /// 테스트용.
  @Get(path: '/profile')
  Future<Response> myProfile();
}
