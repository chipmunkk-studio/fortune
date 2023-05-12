import 'package:foresh_flutter/core/error/fortune_error_mapper.dart';
import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/datasources/reward_datasource.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_product_entity.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';

class RewardRepositoryImpl implements RewardRepository {
  final RewardDataSource rewardDataSource;
  final FortuneErrorMapper errorMapper;

  RewardRepositoryImpl({
    required this.rewardDataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneResult<RewardEntity>> getRewardProducts(int page) async {
    final remoteData = await rewardDataSource.getRewardProducts(page).toRemoteDomainData(errorMapper);
    return remoteData;
  }

  @override
  Future<FortuneResult<RewardProductEntity>> getRewardProductDetail(int id) async {
    final remoteData = await rewardDataSource.getRewardDetail(id).toRemoteDomainData(errorMapper);
    return remoteData;
  }

  @override
  Future<FortuneResult<void>> requestRewardExchange(int id) async {
    final remoteData = await rewardDataSource.postRewardExchange(id).toRemoteDomainData(errorMapper);
    return remoteData;
  }
}
