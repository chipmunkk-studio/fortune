import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/presentation/main/component/map/main_location_data.dart';

class GetObtainableMarkerUseCase implements UseCase1<FortuneUserEntity, MainLocationData> {
  final UserRepository userRepository;
  final MarkerRepository markerRepository;

  GetObtainableMarkerUseCase({
    required this.userRepository,
    required this.markerRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call(MainLocationData data) async {
    try {
      final user = await userRepository.findUserByPhone();
      final marker = await markerRepository.findMarkerById(data.id);
      // 유저의 티켓이 없고, 리워드 티켓이 감소 일 경우.
      if (user.ticket <= 0 && data.ingredient.rewardTicket < 0) {
        throw CommonFailure(errorMessage: '보유한 티켓이 없습니다');
      }
      return Right(user);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
