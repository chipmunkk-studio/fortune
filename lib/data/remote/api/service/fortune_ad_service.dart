import 'package:chopper/chopper.dart';
import 'package:fortune/data/remote/request/request_show_ad_complete.dart';

part 'fortune_ad_service.chopper.dart';

@ChopperApi(baseUrl: "api/v1/ads")
abstract class FortuneAdService extends ChopperService {
  static FortuneAdService create([ChopperClient? client]) => _$FortuneAdService(client);

  @Post(path: '/complete/hmac')
  Future<Response> onShowAdComplete(@Body() RequestShowAdComplete request);
}
