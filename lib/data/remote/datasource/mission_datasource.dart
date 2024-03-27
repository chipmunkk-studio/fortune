import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/api/service/mission_service.dart';
import 'package:fortune/data/remote/request/request_mission_acquire.dart';
import 'package:fortune/data/remote/response/fortune_user_response.dart';
import 'package:fortune/data/remote/response/mission_list_response.dart';
import 'package:fortune/data/remote/response/mission_response.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/mission_entity.dart';
import 'package:fortune/domain/entity/mission_list_entity.dart';

abstract class MissionDataSource {
  Future<MissionListEntity> missionList();

  Future<MissionEntity> missionDetail(String id);

  Future<FortuneUserEntity> missionAcquire(RequestMissionAcquire request);
}

class MissionDataSourceImpl extends MissionDataSource {
  final MissionService missionsService;

  MissionDataSourceImpl({
    required this.missionsService,
  });

  @override
  Future<FortuneUserEntity> missionAcquire(RequestMissionAcquire request) async {
    return await missionsService.missionAcquire(request).then(
          (value) => FortuneUserResponse.fromJson(
            value.toResponseData(),
          ),
        );
  }

  @override
  Future<MissionEntity> missionDetail(String id) async {
    return await missionsService.missionDetail(id).then(
          (value) => MissionResponse.fromJson(
            value.toResponseData(),
          ),
        );
  }

  @override
  Future<MissionListEntity> missionList() async {
    return await missionsService.missions().then(
          (value) => MissionListResponse.fromJson(
        value.toResponseData(),
      ),
    );
  }
}
