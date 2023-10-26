import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/response/obtain_history_response.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_detail_entity.dart';
import 'package:fortune/domain/supabase/repository/mission_respository.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class GetMissionDetailUseCase implements UseCase1<MissionDetailEntity, int> {
  final MissionsRepository missionRepository;
  final ObtainHistoryRepository obtainHistoryRepository;
  final UserRepository userRepository;

  GetMissionDetailUseCase({
    required this.missionRepository,
    required this.userRepository,
    required this.obtainHistoryRepository,
  });

  @override
  Future<FortuneResult<MissionDetailEntity>> call(int missionId) async {
    try {
      final user = await userRepository.findUserByEmailNonNull(columnsToSelect: [UserColumn.id]);
      final mission = await missionRepository.getMissionById(missionId);
      final clearConditions = await missionRepository.getMissionClearConditionsByMissionId(missionId);
      final userHistories = await obtainHistoryRepository.getHistoriesByUser(
        user.id,
        columnsToSelect: [
          ObtainHistoryColumn.ingredient,
        ],
      );

      // 재료가 있는 것 끼리만 추스림.
      final filteredUserHistories = userHistories
          .where((history) => clearConditions.any((condition) => condition.ingredient.id == history.ingredient.id))
          .toList();

      // 마커 목록 뽑음.
      List<MissionDetailViewItemEntity> markers = clearConditions.map((condition) {
        int haveCount = filteredUserHistories
            .where(
              (history) => history.ingredient.id == condition.ingredient.id,
            )
            .length;
        return MissionDetailViewItemEntity(
          ingredient: condition.ingredient,
          haveCount: haveCount,
          requireCount: condition.requireCount,
        );
      }).toList();

      // 7개까지 무조건 채움.
      while (markers.length < 7) {
        markers.add(MissionDetailViewItemEntity.empty());
      }

      return Right(
        MissionDetailEntity(
          user: user,
          markers: markers,
          mission: mission,
        ),
      );
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
