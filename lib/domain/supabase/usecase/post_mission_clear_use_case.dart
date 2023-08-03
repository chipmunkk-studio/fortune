import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/obtain_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/mission_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_post_mission_clear.dart';

class PostMissionClearUseCase implements UseCase1<void, RequestPostNormalMissionClear> {
  final MissionsRepository missionRepository;
  final UserRepository userRepository;
  final ObtainHistoryRepository obtainHistoryRepository;

  PostMissionClearUseCase({
    required this.missionRepository,
    required this.userRepository,
    required this.obtainHistoryRepository,
  });

  @override
  Future<FortuneResult<void>> call(RequestPostNormalMissionClear request) async {
    try {
      final user = await userRepository.findUserByPhoneNonNull();
      final clearConditions = await missionRepository.getMissionClearConditions(request.missionId);
      final userHistories = await obtainHistoryRepository.getHistoriesByUser(userId: user.id);

      // 미션 클리어.
      final missions = await missionRepository.postMissionClear(
        missionId: request.missionId,
        userId: user.id,
      );

      // 삭제 대상인 것들만 다넣음.
      List<ObtainHistoryEntity> filteredUserHistories = [];

      for (var condition in clearConditions) {
        var matchedHistories = userHistories.where((history) => history.ingredient.id == condition.ingredient.id);
        filteredUserHistories.addAll(matchedHistories.take(condition.requireCount));
      }

      // 히스토리에서 삭제.
      await obtainHistoryRepository.delete(histories: filteredUserHistories);

      return Right(missions);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
