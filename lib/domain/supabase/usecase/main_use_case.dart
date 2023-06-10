import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/main_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/ingredient_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_main_param.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainUseCase implements UseCase1<MainEntity, RequestMainParam> {
  final IngredientRepository ingredientRepository;
  final MarkerRepository markerRepository;
  final UserRepository userRepository;

  MainUseCase({
    required this.ingredientRepository,
    required this.markerRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<MainEntity>> call(RequestMainParam param) async {
    // 내 주변 마커들 가져오기.
    try {
      // 유저 정보 가져오기.(무조건 가져옴)
      final user = await userRepository
          .findUserByPhone(Supabase.instance.client.auth.currentUser?.phone)
          .then((value) => value.getOrElse(() => null)!);

      // 내 주변의 마커를 가져옴.
      var markersNearByMe = await markerRepository
          .getAllMarkers(param.latitude, param.longitude)
          .then((value) => value.getOrElse(() => List.empty()));

      final ingredients = await ingredientRepository.getIngredients();
      // 주변에 마커가 없으면 2개 있으면 0개.
      final markerCount = markersNearByMe.isEmpty || markersNearByMe.length <= 2 ? 1 : 0;
      final isTicketEmpty = markersNearByMe.where((element) => element.ingredient.type == IngredientType.ticket).toList().isEmpty;
      // 티켓이 없으면 3개 뿌려 주고 아니면 1개 뿌려줌.
      final ticketCount = isTicketEmpty ? 3 : 0;

      // 주변에 마커가 없다면 랜덤 생성.
      // 내 위치를 중심으로 랜덤 생성.
      final result = await markerRepository
          .getRandomMarkers(
            latitude: param.latitude,
            longitude: param.longitude,
            ingredients: ingredients,
            ticketCount: ticketCount,
            markerCount: markerCount,
          )
          .then((value) => value.getOrElse(() => false));

      // 내 주변의 마커 가져옴
      if (result) {
        markersNearByMe = await markerRepository
            .getAllMarkers(param.latitude, param.longitude)
            .then((value) => value.getOrElse(() => List.empty()));
      }

      return Right(
        MainEntity(
          user: user,
          markers: markersNearByMe,
        ),
      );
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
