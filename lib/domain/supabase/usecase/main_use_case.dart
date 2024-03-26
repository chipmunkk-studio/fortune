import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/response/alarmfeed/alarm_feeds_response.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/response/obtain_history_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/main_view_entity.dart';
import 'package:fortune/domain/supabase/repository/alarm_feeds_repository.dart';
import 'package:fortune/domain/supabase/repository/ingredient_respository.dart';
import 'package:fortune/domain/supabase/repository/marker_respository.dart';
import 'package:fortune/domain/supabase/repository/mission_respository.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_main_param.dart';
import 'package:fortune/env.dart';

class MainUseCase implements UseCase1<MainViewEntity, RequestMainParam> {
  final IngredientRepository ingredientRepository;
  final ObtainHistoryRepository obtainHistoryRepository;
  final MarkerRepository markerRepository;
  final AlarmFeedsRepository userNoticesRepository;
  final MissionsRepository missionsRepository;
  final UserRepository userRepository;
  final FortuneRemoteConfig remoteConfig;

  MainUseCase({
    required this.remoteConfig,
    required this.ingredientRepository,
    required this.markerRepository,
    required this.userRepository,
    required this.obtainHistoryRepository,
    required this.missionsRepository,
    required this.userNoticesRepository,
  });

  @override
  Future<FortuneResultDeprecated<MainViewEntity>> call(RequestMainParam param) async {
    try {
      // 유저 정보 가져오기.
      final user = await userRepository.findUserByEmailNonNull(columnsToSelect: [
        UserColumn.id,
        UserColumn.email,
        UserColumn.markerObtainCount,
        UserColumn.level,
        UserColumn.ticket,
        UserColumn.profileImage,
      ]);

      // 유저 알림 가져오기. (안읽은거 하나라도 있는지.)
      final userAlarms = await userNoticesRepository.findAllAlarmsByUserId(
        user.id,
        columnsToSelect: [
          AlarmFeedColumn.isRead,
        ],
      );
      final bool hasNewAlarm = userAlarms.any((element) => !element.isRead);

      // 내 주변의 마커를 가져옴.
      var markersNearByMe = (await markerRepository.getAllMarkers(param.latitude, param.longitude)).toList();

      // 내가 보유한 마커 수.
      final haveCounts = await obtainHistoryRepository.getHistoriesByUser(
        user.id,
        columnsToSelect: [
          ObtainHistoryColumn.id,
        ],
      );

      // 내 주변 마커 리스트.(티켓 X, 노말O, 스페셜O, 랜덤스크래치O)
      /// 여기에서 코인을 제외한 내 주변의 마커들을 가져옴.
      /// 서버컨트롤, 노말, 랜덤박스(싱글,멀티)
      final markersNearsByMeWithNotTicket = markersNearByMe
          .where(
            (element) =>
                element.ingredient.type != IngredientType.coin &&
                (element.ingredient.type == IngredientType.normal ||
                    element.ingredient.type == IngredientType.randomScratchSingle ||
                    element.ingredient.type == IngredientType.randomScratchMulti ||
                    element.ingredient.type == IngredientType.special),
          )
          .toList();

      // 미션 클리어 히스토리.
      final missionClearHistories = await missionsRepository.getMissionClearUsers();

      // 재료 목록 가져옴.
      final ingredients = await ingredientRepository.findAllIngredients();

      final keepMarkerCount = kReleaseMode ? remoteConfig.markerCount : 20;
      final keepTicketCount = kReleaseMode ? remoteConfig.ticketCount : 2;

      final markerCount = markersNearsByMeWithNotTicket.length < keepMarkerCount
          ? keepMarkerCount - markersNearsByMeWithNotTicket.length
          : 0;

      final coins = markersNearByMe
          .where(
            (element) => element.ingredient.type == IngredientType.coin,
          )
          .toList();

      // 코인 없으면 N개 뿌려주고 아니면 3-N개 뿌려줌.
      final coinCounts = coins.length < keepTicketCount ? keepTicketCount - coins.length : 0;

      // 주변에 마커가 없다면, 필요한 개수 만큼 내 위치를 중심으로 랜덤 생성.
      final result = await markerRepository.getRandomMarkers(
        latitude: param.latitude,
        longitude: param.longitude,
        ingredients: ingredients,
        coinCounts: coinCounts,
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
          missionClearUsers: missionClearHistories,
          hasNewAlarm: hasNewAlarm,
          haveCount: haveCounts.length,
        ),
      );
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
