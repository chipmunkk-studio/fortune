import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/response/mission/mission_ext.dart';
import 'package:fortune/domain/supabase/entity/marker_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_view_entity.dart';
import 'package:fortune/domain/supabase/repository/mission_respository.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class GetMissionsUseCase implements UseCase0<List<MissionViewEntity>> {
  final MissionsRepository missionRepository;
  final ObtainHistoryRepository obtainHistoryRepository;
  final UserRepository userRepository;

  GetMissionsUseCase({
    required this.missionRepository,
    required this.obtainHistoryRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<List<MissionViewEntity>>> call() async {
    try {
      final user = await userRepository.findUserByEmailNonNull();
      final missions = await missionRepository.getAllMissions();
      final missionViewItemsFutures = missions.map(
        (e) async {
          // 클리어 조건들을 가져옴.
          final clearConditions = await missionRepository.getMissionClearConditionsByMissionId(e.id);

          // 사용자가 갖고있는 재료의 획득량.
          final userHaveCountFutures = clearConditions.map((e) async {
            final history = await obtainHistoryRepository.getHistoriesByUserAndIngredient(
              userId: user.id,
              ingredientId: e.ingredient.id,
            );
            return history.length;
          }).toList();

          // 사용자의 총 획득량.
          final userHaveCount = (await Future.wait(userHaveCountFutures)).reduce((a, b) => a + b).toInt();

          // 클리어에 필요한 총 획득량.
          final requireCount = clearConditions.map((e) => e.requireCount).reduce((a, b) => a + b).toInt();

          // 릴레이마커
          final relayMarker =
              (e.missionType == MissionType.relay) ? clearConditions.single.marker : MarkerEntity.empty();

          return MissionViewEntity(
            mission: e,
            relayMarker: relayMarker,
            userHaveCount: userHaveCount,
            requiredTotalCount: requireCount,
          );
        },
      );
      final List<MissionViewEntity> missionViewItems = await Future.wait(missionViewItemsFutures);

      missionViewItems.sort((a, b) {
        // 1순위: userHaveCount가 requiredTotalCount보다 크거나 같은 경우
        if (a.userHaveCount >= a.requiredTotalCount && b.userHaveCount < b.requiredTotalCount) {
          return -1; // a가 앞으로
        } else if (b.userHaveCount >= b.requiredTotalCount && a.userHaveCount < a.requiredTotalCount) {
          return 1; // b가 앞으로
        } else {
          // 2순위: userHaveCount 기준으로 내림차순 정렬
          if (a.userHaveCount != b.userHaveCount) {
            return b.userHaveCount.compareTo(a.userHaveCount);
          } else {
            // 3순위: requiredTotalCount 기준으로 오름차순 정렬
            return a.requiredTotalCount.compareTo(b.requiredTotalCount);
          }
        }
      });
      return Right(missionViewItems);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
