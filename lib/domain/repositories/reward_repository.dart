import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_product_entity.dart';

abstract class RewardRepository {
  Future<FortuneResult<RewardEntity>> getRewardProducts(int page);

  Future<FortuneResult<RewardProductEntity>> getRewardProductDetail(int id);
  Future<FortuneResult<void>> requestRewardExchange(int id);
}
