import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/reward_entity.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';

class ObtainRewardProductsUseCase implements UseCase0<RewardEntity> {
  final RewardRepository repository;

  ObtainRewardProductsUseCase(this.repository);

  @override
  Future<FortuneResult<RewardEntity>> call() async {
    return await repository.getRewardProducts();
  }
}
