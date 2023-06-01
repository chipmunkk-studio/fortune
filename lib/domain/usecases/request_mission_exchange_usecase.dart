import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';

class RequestRewardExchangeUseCase implements UseCase1<void, int> {
  final MissionRepository repository;

  RequestRewardExchangeUseCase(this.repository);

  @override
  Future<FortuneResult<void>> call(int rewardId) async {
    return await repository.requestRewardExchange(rewardId);
  }
}
