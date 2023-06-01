import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_detail_entity.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';

class ObtainMissionDetailUseCase implements UseCase1<MissionDetailEntity, int> {
  final MissionRepository repository;

  ObtainMissionDetailUseCase(this.repository);

  @override
  Future<FortuneResult<MissionDetailEntity>> call(int id) async {
    return await repository.getMissionDetail(id);
  }
}
