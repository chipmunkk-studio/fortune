import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/network/api/request/request_reward_exchange.dart';
import 'package:foresh_flutter/core/network/api/service/reward_service.dart';
import 'package:foresh_flutter/data/responses/reward/reward_product_response.dart';
import 'package:foresh_flutter/data/responses/reward/reward_response.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_product_entity.dart';

abstract class RewardDataSource {
  Future<RewardEntity> getRewardProducts(int page);

  Future<RewardProductEntity> getRewardDetail(int id);

  Future<void> postRewardExchange(int id);
}

class RewardDataSourceImpl extends RewardDataSource {
  final RewardService rewardService;

  RewardDataSourceImpl(this.rewardService);

  @override
  Future<RewardEntity> getRewardProducts(int page) async {
    final response = await rewardService.rewards(page: page).then((value) => value.toResponseData());
    final entity = RewardResponse.fromJson(response);
    return entity;
  }

  @override
  Future<RewardProductEntity> getRewardDetail(int id) async {
    final response = await rewardService.rewardDetail(id).then((value) => value.toResponseData());
    final entity = RewardProductResponse.fromJson(response);
    return entity;
  }

  @override
  Future<void> postRewardExchange(int id) async {
    final response = await rewardService
        .rewardExchange(
          RequestRewardExchange(
            rewardId: id,
          ),
        )
        .then((value) => value.toResponseData());
    return response;
  }
}
