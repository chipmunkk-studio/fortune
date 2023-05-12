import 'package:chopper/chopper.dart';
import 'package:foresh_flutter/core/network/api/request/request_reward_exchange.dart';

part 'reward_service.chopper.dart';

@ChopperApi(baseUrl: "/v1/reward/")
abstract class RewardService extends ChopperService {
  static RewardService create([ChopperClient? client]) => _$RewardService(client);

  // 리워드 상품 목록 조회.
  @Get()
  Future<Response> rewards({
    @Query('offset') int page = 0,
    @Query('limit') int limit = 30,
  });

  // 리워드 상품 상세 조회.
  @Get(path: "{id}")
  Future<Response> rewardDetail(
    @Path('id') int id,
  );

  // 리워드 상품 신청.
  @Post(path: "exchange")
  Future<Response> rewardExchange(
    @Body() RequestRewardExchange request,
  );
}
