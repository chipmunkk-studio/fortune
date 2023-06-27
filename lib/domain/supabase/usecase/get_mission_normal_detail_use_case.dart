import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/normal_mission_detail_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/normal_mission_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetMissionNormalDetailUseCase implements UseCase1<MissionNormalDetailEntity, int> {
  final MissionNormalRepository missionRepository;
  final ObtainHistoryRepository obtainHistoryRepository;
  final UserRepository userRepository;

  GetMissionNormalDetailUseCase({
    required this.missionRepository,
    required this.userRepository,
    required this.obtainHistoryRepository,
  });

  @override
  Future<FortuneResult<MissionNormalDetailEntity>> call(int missionId) async {
    try {
      final user = await userRepository.findUserByPhone();
      final mission = await missionRepository.getMissionById(missionId);
      final clearConditions = await missionRepository.getMissionClearConditions(missionId);
      final userHistories = await obtainHistoryRepository.getHistoriesByUser(userId: user.id);

      // 재료가 있는 것 끼리만 추스림.
      final filteredUserHistories = userHistories
          .where((history) => clearConditions.any((condition) => condition.ingredient.id == history.ingredient.id))
          .toList();

      // 마커 목록 뽑음.
      List<NormalMissionDetailViewItemEntity> markers = clearConditions.map((condition) {
        int haveCount = filteredUserHistories
            .where(
              (history) => history.ingredient.id == condition.ingredient.id,
            )
            .length;
        return NormalMissionDetailViewItemEntity(
          ingredient: condition.ingredient,
          haveCount: haveCount,
          requireCount: condition.count,
        );
      }).toList();

      // 7개까지 무조건 채움.
      while (markers.length < 7) {
        markers.add(NormalMissionDetailViewItemEntity.empty());
      }

      return Right(
        MissionNormalDetailEntity(
          markers: markers,
          mission: mission,
        ),
      );
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
