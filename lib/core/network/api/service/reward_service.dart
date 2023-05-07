import 'package:chopper/chopper.dart';

part 'reward_service.chopper.dart';

@ChopperApi(baseUrl: "/v1/reward")
abstract class RewardService extends ChopperService {
  static RewardService create([ChopperClient? client]) => _$RewardService(client);

  // 리워드 상품 목록 조회.
  @Get(path: "?offset=0&limit=10")
  Future<Response> rewards();
}
