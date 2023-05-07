import 'package:foresh_flutter/core/error/fortune_error_mapper.dart';
import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/datasources/reward_datasource.dart';
import 'package:foresh_flutter/domain/entities/reward_entity.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';

class RewardRepositoryImpl implements RewardRepository {
  final RewardDataSource rewardDataSource;
  final FortuneErrorMapper errorMapper;

  RewardRepositoryImpl({
    required this.rewardDataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneResult<RewardEntity>> getRewardProducts() async {
    final remoteData = await rewardDataSource.getRewardProducts().toRemoteDomainData(errorMapper);
    return remoteData;
  }
}
