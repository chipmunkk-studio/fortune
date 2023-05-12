import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_entity.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';

class ObtainRewardProductsUseCase implements UseCase1<RewardEntity, int> {
  final RewardRepository repository;

  ObtainRewardProductsUseCase(this.repository);

  @override
  Future<FortuneResult<RewardEntity>> call(int page) async {
    return await repository.getRewardProducts(page);
  }
}
