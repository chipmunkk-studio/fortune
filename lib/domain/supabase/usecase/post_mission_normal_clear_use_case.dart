import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/obtain_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/normal_mission_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_post_mission_clear.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostMissionNormalClearUseCase implements UseCase1<void, RequestPostNormalMissionClear> {
  final MissionNormalRepository missionRepository;
  final UserRepository userRepository;
  final ObtainHistoryRepository obtainHistoryRepository;

  PostMissionNormalClearUseCase({
    required this.missionRepository,
    required this.userRepository,
    required this.obtainHistoryRepository,
  });

  @override
  Future<FortuneResult<void>> call(RequestPostNormalMissionClear request) async {
    try {
      final user = await userRepository.findUserByPhone();
      final clearConditions = await missionRepository.getMissionClearConditions(request.missionId);
      final userHistories = await obtainHistoryRepository.getHistoriesByUser(userId: user.id);

      // 미션 클리어.
      final missions = await missionRepository.postMissionClear(
        missionId: request.missionId,
        email: request.email,
      );

      // 삭제 대상인 것들만 다넣음.
      List<ObtainHistoryEntity> filteredUserHistories = [];
      for (var condition in clearConditions) {
        var matchedHistories = userHistories.where((history) => history.ingredient.id == condition.ingredient.id);
        filteredUserHistories.addAll(matchedHistories.take(condition.count));
      }

      // 히스토리에서 삭제.
      await obtainHistoryRepository.delete(histories: filteredUserHistories);
      return Right(missions);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
