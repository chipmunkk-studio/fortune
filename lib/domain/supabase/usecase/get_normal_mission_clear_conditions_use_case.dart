import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/normal_mission_clear_condition_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/normal_mission_respository.dart';

class GetNormalMissionClearConditionsUseCase implements UseCase1<List<NormalMissionClearConditionEntity>, int> {
  final NormalMissionRepository missionRepository;

  GetNormalMissionClearConditionsUseCase({
    required this.missionRepository,
  });

  @override
  Future<FortuneResult<List<NormalMissionClearConditionEntity>>> call(int missionId) async {
    try {
      final missions = await missionRepository.getMissionClearConditions(missionId);
      return Right(missions);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
