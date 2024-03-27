import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/mission_entity.dart';
import 'package:fortune/domain/entity/mission_list_entity.dart';

abstract class MissionRepository {
  /// 미션 조회
  Future<MissionListEntity> missionList();

  /// 미션 클리어
  Future<FortuneUserEntity> missionAcquire({
    required String id,
    required int ts,
  });

  /// 미션 상세
  Future<MissionEntity> missionDetail(String id);
}
