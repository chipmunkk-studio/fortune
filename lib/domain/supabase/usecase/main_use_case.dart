import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/obtain_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/ingredient_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_main_param.dart';
import 'package:foresh_flutter/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainUseCase implements UseCase1<MainViewItem, RequestMainParam> {
  final IngredientRepository ingredientRepository;
  final ObtainHistoryRepository obtainHistoryRepository;
  final MarkerRepository markerRepository;
  final UserRepository userRepository;
  final FortuneRemoteConfig remoteConfig;

  MainUseCase({
    required this.remoteConfig,
    required this.ingredientRepository,
    required this.markerRepository,
    required this.userRepository,
    required this.obtainHistoryRepository,
  });

  @override
  Future<FortuneResult<MainViewItem>> call(RequestMainParam param) async {
    try {
      // 유저 정보 가져오기.
      final user = await userRepository.findUserByPhone(Supabase.instance.client.auth.currentUser?.phone);

      // 내 주변의 마커를 가져옴. (글로벌 여부 확인)
      var markersNearByMe = (await markerRepository.getAllMarkers(param.latitude, param.longitude))
          .where(
            (element) =>
                user.isGlobal == element.ingredient.isGlobal || element.ingredient.type == IngredientType.ticket,
          )
          .toList();

      // 내가 보유한 마커 수.
      final haveCounts = await obtainHistoryRepository.getHistoriesByUser(userId: user.id);

      // 마커 리스트.
      final markersNearsByMeWithNotTicket = markersNearByMe
          .where(
            (element) => element.ingredient.type != IngredientType.ticket,
          )
          .toList();

      // 히스토리 목록 가져옴.
      final histories = (await obtainHistoryRepository.getAllHistories(start: 0, end: 10))
          .map(
            (e) => ObtainHistoryContentViewItem(
              id: e.id,
              markerId: e.markerId,
              user: e.user,
              ingredient: e.ingredient,
              createdAt: e.createdAt,
              ingredientName: e.ingredientName,
              locationName: e.user.isGlobal ? e.enLocationName : e.krLocationName,
              nickName: e.nickName,
            ),
          )
          .toList();

      // 재료 목록 가져옴.
      final ingredients = await ingredientRepository.getIngredients(user.isGlobal);
      final keepMarkerCount = remoteConfig.markerCount;
      final keepTicketCount = remoteConfig.ticketCount;

      // 주변에 마커가 없으면 1개 있으면 0개.
      final markerCount = markersNearsByMeWithNotTicket.length < keepMarkerCount
          ? keepMarkerCount - markersNearsByMeWithNotTicket.length
          : 0;
      final isTicketEmpty = markersNearByMe
          .where(
            (element) => element.ingredient.type == IngredientType.ticket,
          )
          .toList();

      // 티켓이 없으면 3개 뿌려주고 아니면 3-N개 뿌려줌.
      final ticketCount = isTicketEmpty.length < keepTicketCount ? keepTicketCount - isTicketEmpty.length : 0;

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

      // 내 주변의 마커 가져옴 (티켓, 글로벌 여부 확인)
      if (result) {
        markersNearByMe = (await markerRepository.getAllMarkers(param.latitude, param.longitude))
            .where(
              (element) =>
                  user.isGlobal == element.ingredient.isGlobal || element.ingredient.type == IngredientType.ticket,
            )
            .toList();
      }

      return Right(
        MainViewItem(
          user: user,
          markers: markersNearByMe,
          histories: histories,
          haveCount: haveCounts.length + user.trashObtainCount,
        ),
      );
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}

class MainViewItem {
  final FortuneUserEntity user;
  final List<MarkerEntity> markers;
  final List<ObtainHistoryContentViewItem> histories;
  final int haveCount;

  MainViewItem({
    required this.user,
    required this.markers,
    required this.histories,
    required this.haveCount,
  });
}
