import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/main_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/ingredient_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_main_param.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainUseCase implements UseCase1<MainEntity, RequestMainParam> {
  final IngredientRepository ingredientRepository;
  final ObtainHistoryRepository obtainHistoryRepository;
  final MarkerRepository markerRepository;
  final UserRepository userRepository;

  MainUseCase({
    required this.ingredientRepository,
    required this.markerRepository,
    required this.userRepository,
    required this.obtainHistoryRepository,
  });

  @override
  Future<FortuneResult<MainEntity>> call(RequestMainParam param) async {
    try {
      // 유저 정보 가져오기.(무조건 가져옴)
      final user = await userRepository
          .findUserByPhone(Supabase.instance.client.auth.currentUser?.phone)
          .then((value) => value.getOrElse(() => null)!);

      // 내 주변의 마커를 가져옴.
      var markersNearByMe = await markerRepository.getAllMarkers(param.latitude, param.longitude);

      // 마커 리스트.
      final markersNearsByMeWithNotTicket = markersNearByMe
          .where(
            (element) => element.ingredient.type != IngredientType.ticket,
          )
          .toList();

      // 히스토리 목록 가져옴.
      final histories = await obtainHistoryRepository.getAllHistories(start: 0, end: 10);

      // 재료 목록 가져옴.
      final ingredients = await ingredientRepository.getIngredients();

      // 주변에 마커가 없으면 1개 있으면 0개.
      final markerCount = markersNearsByMeWithNotTicket.isEmpty || markersNearsByMeWithNotTicket.length < 2 ? 1 : 0;
      final isTicketEmpty =
          markersNearByMe.where((element) => element.ingredient.type == IngredientType.ticket).toList();

      // 티켓이 없으면 3개 뿌려주고 아니면 3-N개 뿌려줌.
      final ticketCount = isTicketEmpty.length < 3 ? 3 - isTicketEmpty.length : 0;

      FortuneLogger.info(
          "markersNearByMe: ${markersNearByMe.length}, markerCount: $markerCount, ticketCount: $ticketCount");

      // 주변에 마커가 없다면 랜덤 생성.
      // 내 위치를 중심으로 랜덤 생성.
      final result = await markerRepository.getRandomMarkers(
        latitude: param.latitude,
        longitude: param.longitude,
        ingredients: ingredients,
        ticketCount: ticketCount,
        markerCount: markerCount,
      );

      // 내 주변의 마커 가져옴
      if (result) {
        markersNearByMe = await markerRepository.getAllMarkers(param.latitude, param.longitude);
      }

      return Right(
        MainEntity(
          user: user,
          markers: markersNearByMe,
          histories: histories,
        ),
      );
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
