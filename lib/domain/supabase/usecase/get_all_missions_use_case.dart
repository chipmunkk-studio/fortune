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

      final missionViewItemsFutures = missions.map((e) async {
        // 클리어 조건들을 가져옴.
        final clearConditions = await missionRepository.getMissionClearConditions(e.id);

        // 쓰레기 수건 미션 여부. (아이템중에 티켓이 있는 경우)
        final isEmptyTicketMission =
            clearConditions.where((element) => element.ingredient.type == IngredientType.ticket).toList().isNotEmpty;

        // 미션에 필요한 사용자 티켓 갯수.
        final userHaveCountFutures = clearConditions.map((e) async {
          final history = await obtainHistoryRepository.getHistoriesByUserAndIngredient(
            userId: user.id,
            ingredientId: e.ingredient.id,
          );
          return history.length;
        }).toList();

        // 사용자의 총 획득량.
        final userHaveCount = isEmptyTicketMission
            ? user.trashObtainCount
            : (await Future.wait(userHaveCountFutures)).reduce((a, b) => a + b).toInt();

        // 클리어에 필요한 총 획득량.
        final totalCount = clearConditions.map((e) => e.count).reduce((a, b) => a + b).toInt();

        return MissionsViewItem(
          mission: e,
          userHaveCount: userHaveCount,
          requiredTotalCount: totalCount,
        );
      });
      final List<MissionsViewItem> missionViewItems = await Future.wait(missionViewItemsFutures);
      return Right(missionViewItems);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
