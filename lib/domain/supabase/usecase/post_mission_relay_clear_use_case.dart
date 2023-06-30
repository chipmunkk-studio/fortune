import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/request/request_user_notices_update.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/normal_mission_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_notices_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';

class PostMissionRelayClearUseCase implements UseCase1<void, int> {
  final MissionsRepository missionRepository;
  final MarkerRepository markerRepository;
  final UserRepository userRepository;
  final UserNoticesRepository userNoticesRepository;

  PostMissionRelayClearUseCase({
    required this.missionRepository,
    required this.markerRepository,
    required this.userRepository,
    required this.userNoticesRepository,
  });

  @override
  Future<FortuneResult<bool>> call(int markerId) async {
    try {
      // 유저 조회.
      final user = await userRepository.findUserByPhone();
      // 마커가 있는 미션을 조회.
      final mission = await missionRepository.getMissionByMarkerId(markerId);
      // 미션 클리어 조건 들을 조회.
      final clearConditions = await missionRepository.getMissionClearConditions(mission.id);
      // 미션 클리어 조건.
      final condition = clearConditions.firstWhereOrNull((element) => element.mission.id == mission.id);
      // 마커 조회.
      final markerEntity = await markerRepository.findMarkerById(markerId);
      // 클리어 조건. (내가 클리어 한 건지)
      final isClear = markerEntity.hitCount == condition?.requireCount && markerEntity.lastObtainUser == user.id;
      if (isClear) {
        // 미션 클리어.
        await missionRepository.postMissionClear(
          missionId: mission.id,
          email: '',
        );
        await userNoticesRepository.insertNotice(
          RequestUserNoticesUpdate(
            title: '릴레이 미션을 클리 하셨습니다.',
            content: '릴레이 미션 클리어!!',
            type: UserNoticeType.relay_mission_clear.name,
            userId: user.id,
            rewardTicket: 20,
          ),
        );
      }
      return Right(isClear);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
