import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/repository/mission_respository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_post_mission_clear.dart';

class PostMissionClearUseCase implements UseCase1<void, RequestPostMissionClear> {
  final MissionRepository missionRepository;

  PostMissionClearUseCase({
    required this.missionRepository,
  });

  @override
  Future<FortuneResult<void>> call(RequestPostMissionClear request) async {
    try {
      final missions = await missionRepository.postMissionClear(
        missionId: request.missionId,
        email: request.email,
      );
      return Right(missions);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
