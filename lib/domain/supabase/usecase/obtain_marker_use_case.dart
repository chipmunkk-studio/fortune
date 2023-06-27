import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/presentation/main/component/map/main_location_data.dart';

class ObtainMarkerUseCase implements UseCase1<FortuneUserEntity, MainLocationData> {
  final MarkerRepository markerRepository;
  final UserRepository userRepository;

  ObtainMarkerUseCase({
    required this.markerRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call(MainLocationData param) async {
    try {
      final marker = await markerRepository.findMarkerById(param.id);
      final ingredient = marker.ingredient;
      final user = await userRepository.findUserByPhone();

      // 마커 획득.
      await markerRepository.obtainMarker(marker: marker, user: user);

      int updatedTicket = user.ticket;
      int markerObtainCount = user.markerObtainCount;

      // 티켓 및 획득 카운트 업데이트.
      updatedTicket = user.ticket + ingredient.rewardTicket;
      markerObtainCount = markerObtainCount + 1;

      // 사용자 티켓 정보 업데이트.
      final updateUser = await userRepository.updateUser(
        user.copyWith(
          // 타이밍 이슈 때문에 1개 더 먹을 수 있음.
          ticket: updatedTicket < 0 ? 0 : updatedTicket,
          markerObtainCount: markerObtainCount,
        ),
      );

      return Right(updateUser);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
