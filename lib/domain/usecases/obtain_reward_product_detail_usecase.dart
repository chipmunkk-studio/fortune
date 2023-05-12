import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_product_entity.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';

class ObtainRewardProductDetailUseCase implements UseCase1<RewardProductEntity, int> {
  final RewardRepository repository;

  ObtainRewardProductDetailUseCase(this.repository);

  @override
  Future<FortuneResult<RewardProductEntity>> call(int id) async {
    return await repository.getRewardProductDetail(id);
  }
}
