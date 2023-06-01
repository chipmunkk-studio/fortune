import 'package:foresh_flutter/core/error/fortune_error_mapper.dart';
import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/datasources/mission_datasource.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_detail_entity.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_entity.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';

class MissionRepositoryImpl implements MissionRepository {
  final MissionDataSource missionDataSource;
  final FortuneErrorMapper errorMapper;

  MissionRepositoryImpl({
    required this.missionDataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneResult<MissionEntity>> getMissions(int page) async {
    final remoteData = await missionDataSource.getMissions(page).toRemoteDomainData(errorMapper);
    return remoteData;
  }

  @override
  Future<FortuneResult<MissionDetailEntity>> getMissionDetail(int id) async {
    final remoteData = await missionDataSource.getMissionDetail(id).toRemoteDomainData(errorMapper);
    return remoteData;
  }

  @override
  Future<FortuneResult<void>> requestRewardExchange(int id) async {
    final remoteData = await missionDataSource.postRewardExchange(id).toRemoteDomainData(errorMapper);
    return remoteData;
  }
}
