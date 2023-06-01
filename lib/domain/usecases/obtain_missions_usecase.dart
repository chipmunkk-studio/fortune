import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/mission/mission_entity.dart';
import 'package:foresh_flutter/domain/repositories/reward_repository.dart';

class ObtainMissionsUseCase implements UseCase1<MissionEntity, int> {
  final MissionRepository repository;

  ObtainMissionsUseCase(this.repository);

  @override
  Future<FortuneResult<MissionEntity>> call(int page) async {
    return await repository.getMissions(page);
  }
}
