import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_clear_condition_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/mission_respository.dart';

class GetMissionClearConditions implements UseCase1<List<MissionClearConditionEntity>, int> {
  final MissionRepository missionRepository;

  GetMissionClearConditions({
    required this.missionRepository,
  });

  @override
  Future<FortuneResult<List<MissionClearConditionEntity>>> call(int missionId) async {
    try {
      final missions = await missionRepository.getMissionClearConditions(missionId);
      return Right(missions);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
