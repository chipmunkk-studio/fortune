import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_detail_entity.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_entity.dart';

abstract class MissionRepository {
  Future<FortuneResult<MissionEntity>> getMissions(int page);

  Future<FortuneResult<MissionDetailEntity>> getMissionDetail(int id);

  Future<FortuneResult<void>> requestRewardExchange(int id);
}
