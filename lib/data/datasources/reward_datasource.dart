import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/network/api/service/reward_service.dart';
import 'package:foresh_flutter/data/responses/reward/reward_response.dart';
import 'package:foresh_flutter/domain/entities/reward_entity.dart';

abstract class RewardDataSource {
  Future<RewardEntity> getRewardProducts();
}

class RewardDataSourceImpl extends RewardDataSource {
  final RewardService rewardService;

  RewardDataSourceImpl(this.rewardService);

  @override
  Future<RewardEntity> getRewardProducts() async {
    final response = await rewardService.rewards().then((value) => value.toResponseData());
    final entity = RewardResponse.fromJson(response);
    return entity;
  }
}
