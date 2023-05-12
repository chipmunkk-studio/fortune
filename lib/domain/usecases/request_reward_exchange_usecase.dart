import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_entity.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';

class RequestRewardExchangeUseCase implements UseCase1<void, int> {
  final RewardRepository repository;

  RequestRewardExchangeUseCase(this.repository);

  @override
  Future<FortuneResult<void>> call(int rewardId) async {
    return await repository.requestRewardExchange(rewardId);
  }
}
