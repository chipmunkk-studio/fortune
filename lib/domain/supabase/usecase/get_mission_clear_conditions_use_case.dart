import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_condition_entity.dart';
import 'package:fortune/domain/supabase/repository/mission_respository.dart';

class GetMissionClearConditionsUseCase implements UseCase1<List<MissionClearConditionEntity>, int> {
  final MissionsRepository missionRepository;

  GetMissionClearConditionsUseCase({
    required this.missionRepository,
  });

  @override
  Future<FortuneResultDeprecated<List<MissionClearConditionEntity>>> call(int missionId) async {
    try {
      final missions = await missionRepository.getMissionClearConditionsByMissionId(missionId);
      return Right(missions);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
