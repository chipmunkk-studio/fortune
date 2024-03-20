import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/response/obtain_history_response.dart';
import 'package:fortune/domain/supabase/entity/obtain_history_entity.dart';
import 'package:fortune/domain/supabase/repository/mission_respository.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_post_mission_clear.dart';

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
  Future<FortuneResultDeprecated<void>> call(RequestPostNormalMissionClear request) async {
    try {
      final user = await userRepository.findUserByEmailNonNull(columnsToSelect: [UserColumn.id]);
      final clearConditions = await missionRepository.getMissionClearConditionsByMissionId(request.missionId);
      final userHistories = await obtainHistoryRepository.getHistoriesByUser(
        user.id,
        columnsToSelect: [
          ObtainHistoryColumn.id,
          ObtainHistoryColumn.ingredient,
        ],
      );

      // 미션 클리어.
      await missionRepository.postMissionClear(
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

      return const Right(null);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
