import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/mission_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostMissionRelayClearUseCase implements UseCase1<void, int> {
  final MissionRepository missionRepository;
  final MarkerRepository markerRepository;
  final UserRepository userRepository;

  PostMissionRelayClearUseCase({
    required this.missionRepository,
    required this.markerRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<bool>> call(int markerId) async {
    try {
      // 유저 조회.
      final user = await userRepository.findUserByPhone(Supabase.instance.client.auth.currentUser?.phone);
      // 마커가 있는 미션을 조회.
      final mission = await missionRepository.getMissionByMarkerId(markerId);
      // 미션 클리어 조건 들을 조회.
      final clearConditions = await missionRepository.getMissionClearConditions(mission.id);
      // 미션 클리어 조건.
      final condition = clearConditions.firstWhereOrNull((element) => element.mission.id == mission.id);
      // 마커 조회.
      final markerEntity = await markerRepository.findMarkerById(markerId);
      // 클리어 조건. (내가 클리어 한 건지)
      final isClear = markerEntity.hitCount == condition?.count && markerEntity.lastObtainUser == user.id;
      if (isClear) {
        // 미션 클리어.
        await missionRepository.postMissionClear(
          missionId: mission.id,
          email: '',
        );
      }
      return Right(isClear);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
