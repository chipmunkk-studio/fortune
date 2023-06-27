import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ObtainMarkerUseCase implements UseCase1<FortuneUserEntity, int> {
  final MarkerRepository markerRepository;
  final UserRepository userRepository;

  ObtainMarkerUseCase({
    required this.markerRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call(int param) async {
    try {
      final marker = await markerRepository.findMarkerById(param);
      final ingredient = marker.ingredient;
      final user = await userRepository.findUserByPhone();

      // 티켓이 없고, 마커가 티켓이 아닐 경우.
      if (user.ticket <= 0 && ingredient.type != IngredientType.ticket) {
        throw CommonFailure(
          errorMessage: "보유한 티켓이 없습니다",
        );
      }
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
          ticket: updatedTicket,
          markerObtainCount: markerObtainCount,
        ),
      );

      return Right(updateUser);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
