import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/reward_entity.dart';

abstract class RewardRepository {
  Future<FortuneResult<RewardEntity>> getRewardProducts();
}
