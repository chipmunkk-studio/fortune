import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/repository/mission_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/presentation/missions/bloc/missions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetAllMissionsUseCase implements UseCase0<List<MissionsViewItem>> {
  final MissionRepository missionRepository;
  final ObtainHistoryRepository obtainHistoryRepository;
  final UserRepository userRepository;

  GetAllMissionsUseCase({
    required this.missionRepository,
    required this.obtainHistoryRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<List<MissionsViewItem>>> call() async {
    try {
      final user = await userRepository.findUserByPhone(Supabase.instance.client.auth.currentUser?.phone);
      final missions = await missionRepository.getAllMissions(user.isGlobal);

      final missionViewItemsFutures = missions.map(
        (e) async {
          // 클리어 조건들을 가져옴.
          final clearConditions = await missionRepository.getMissionClearConditions(e.id);

          // 사용자의 총 획득량.
          final userHaveCount = await () async {
            // 쓰레기 수집 미션 여부.
            if (e.type == MissionType.trash) {
              return user.trashObtainCount;
            } else if (e.type == MissionType.relay) {
              // 릴레이 미션일 경우 히트 카운트.
              return e.marker?.hitCount ?? 0;
            } else {
              // 미션에 필요한 사용자 티켓 갯수.
              final userHaveCountFutures = clearConditions.map((e) async {
                final history = await obtainHistoryRepository.getHistoriesByUserAndIngredient(
                  userId: user.id,
                  ingredientId: e.ingredient.id,
                );
                return history.length;
              }).toList();
              return (await Future.wait(userHaveCountFutures)).reduce((a, b) => a + b).toInt();
            }
          }();

          // 클리어에 필요한 총 획득량.
          final totalCount = clearConditions.map((e) => e.count).reduce((a, b) => a + b).toInt();
          return MissionsViewItem(
            mission: e,
            userHaveCount: userHaveCount,
            requiredTotalCount: totalCount,
          );
        },
      );
      final List<MissionsViewItem> missionViewItems = await Future.wait(missionViewItemsFutures);
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
