import 'package:fortune/data/error/fortune_error_mapper.dart';
import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/datasource/mission_datasource.dart';
import 'package:fortune/data/remote/request/request_mission_acquire.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/mission_entity.dart';
import 'package:fortune/domain/entity/mission_list_entity.dart';
import 'package:fortune/domain/repository/mission_repository.dart';

class MissionRepositoryImpl implements MissionRepository {
  final MissionDataSource missionDataSource;
  final FortuneErrorMapper errorMapper;

  MissionRepositoryImpl({
    required this.missionDataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneUserEntity> missionAcquire({
    required String id,
    required int ts,
  }) async {
    try {
      final remoteData = await missionDataSource
          .missionAcquire(
            RequestMissionAcquire(
              id: id,
              ts: ts,
            ),
          )
          .toRemoteDomainData(errorMapper);
      return remoteData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MissionEntity> missionDetail(String id) async {
    try {
      final remoteData = await missionDataSource.missionDetail(id).toRemoteDomainData(errorMapper);
      return remoteData;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MissionListEntity> missionList() async {
    try {
      final remoteData = await missionDataSource.missionList().toRemoteDomainData(errorMapper);
      return remoteData;
    } catch (e) {
      rethrow;
    }
  }
}
