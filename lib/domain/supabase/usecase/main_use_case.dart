import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/domain/supabase/entity/main_view_entity.dart';
import 'package:fortune/domain/supabase/entity/obtain_history_entity.dart';
import 'package:fortune/domain/supabase/repository/alarm_feeds_repository.dart';
import 'package:fortune/domain/supabase/repository/ingredient_respository.dart';
import 'package:fortune/domain/supabase/repository/marker_respository.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_main_param.dart';
import 'package:fortune/env.dart';

class MainUseCase implements UseCase1<MainViewEntity, RequestMainParam> {
  final IngredientRepository ingredientRepository;
  final ObtainHistoryRepository obtainHistoryRepository;
  final MarkerRepository markerRepository;
  final AlarmFeedsRepository userNoticesRepository;
  final UserRepository userRepository;
  final FortuneRemoteConfig remoteConfig;

  MainUseCase({
    required this.remoteConfig,
    required this.ingredientRepository,
    required this.markerRepository,
    required this.userRepository,
    required this.obtainHistoryRepository,
    required this.userNoticesRepository,
  });

  @override
  Future<FortuneResult<MainViewEntity>> call(RequestMainParam param) async {
    try {
      // 유저 정보 가져오기.
      final user = await userRepository.findUserByPhoneNonNull();

      // 유저 알림 가져오기.
      final userNotices = await userNoticesRepository.findAllAlarmsByUserId(user.id);

      // 내 주변의 마커를 가져옴.
      var markersNearByMe = (await markerRepository.getAllMarkers(param.latitude, param.longitude)).toList();

      // 내가 보유한 마커 수.
      final haveCounts = await obtainHistoryRepository.getHistoriesByUser(userId: user.id);

      // 내 주변 마커 리스트.(티켓 X)
      final markersNearsByMeWithNotTicket = markersNearByMe
          .where(
            (element) => element.ingredient.type != IngredientType.coin,
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
              locationName: e.locationName,
              nickName: e.nickName,
            ),
          )
          .toList();

      // 재료 목록 가져옴.
      final ingredients = await ingredientRepository.findAllIngredients();

      final keepMarkerCount = remoteConfig.markerCount;
      final keepTicketCount = remoteConfig.ticketCount;

      final markerCount = markersNearsByMeWithNotTicket.length < keepMarkerCount
          ? keepMarkerCount - markersNearsByMeWithNotTicket.length
          : 0;

      final isTicketEmpty = markersNearByMe
          .where(
            (element) => element.ingredient.type == IngredientType.coin,
          )
          .toList();

      // 티켓이 없으면 N개 뿌려주고 아니면 3-N개 뿌려줌.
      final ticketCount = isTicketEmpty.length < keepTicketCount ? keepTicketCount - isTicketEmpty.length : 0;

      FortuneLogger.info(
          "markersNearByMe: ${markersNearByMe.length}, markerCount: $markerCount, ticketCount: $ticketCount");

      // 주변에 마커가 없다면, 필요한 개수 만큼 내 위치를 중심으로 랜덤 생성.
      final result = await markerRepository.getRandomMarkers(
        latitude: param.latitude,
        longitude: param.longitude,
        ingredients: ingredients,
        ticketCount: ticketCount,
        markerCount: markerCount,
      );

      // 내 주변의 마커 가져옴.
      if (result) {
        markersNearByMe = (await markerRepository.getAllMarkers(
          param.latitude,
          param.longitude,
        ))
            .toList();
      }

      return Right(
        MainViewEntity(
          user: user,
          markers: markersNearByMe,
          histories: histories,
          notices: userNotices,
          haveCount: haveCounts.length,
        ),
      );
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
