import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/response/mission/mission_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_view_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/mission_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';

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
      final user = await userRepository.findUserByPhoneNonNull();
      final missions = await missionRepository.getAllMissions();

      final missionViewItemsFutures = missions.map(
        (e) async {
          // 클리어 조건들을 가져옴.
          final clearConditions = await missionRepository.getMissionClearConditionsByMissionId(e.id);

          // 사용자 획득량.
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

          if (e.missionType == MissionType.relay) {
            final relayMarker = clearConditions.single.marker;
            return MissionViewEntity(
              mission: e,
              relayMarker: relayMarker, // 릴레이 마커.
              userHaveCount: userHaveCount, // 사용자가 가진 마커 획득 량.
              requiredTotalCount: requireCount, // 요구하는 총 마커 갯수.
            );
          } else {
            return MissionViewEntity(
              mission: e,
              relayMarker: MarkerEntity.empty(),
              userHaveCount: userHaveCount, // 사용자가 가진 마커 획득 량.
              requiredTotalCount: requireCount, // 요구하는 총 마커 갯수.
            );
          }
        },
      );
      final List<MissionViewEntity> missionViewItems = await Future.wait(missionViewItemsFutures);
      // 아이템 정렬.
      missionViewItems.sort((a, b) {
        if (a.userHaveCount >= a.requiredTotalCount && b.userHaveCount < b.requiredTotalCount) {
          return -1;
        } else if (b.userHaveCount >= b.requiredTotalCount && a.userHaveCount < a.requiredTotalCount) {
          return 1;
        } else {
          return 0;
        }
      });
      return Right(missionViewItems);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
