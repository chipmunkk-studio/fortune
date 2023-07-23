import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_notices.dart';
import 'package:foresh_flutter/data/supabase/request/request_obtain_history.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_obtain_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/event_notices_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/event_rewards_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/mission_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_obtain_marker_param.dart';

class ObtainMarkerUseCase implements UseCase1<MarkerObtainEntity, RequestObtainMarkerParam> {
  final MarkerRepository markerRepository;
  final UserRepository userRepository;
  final EventNoticesRepository userNoticesRepository;
  final EventRewardsRepository rewardRepository;
  final ObtainHistoryRepository obtainHistoryRepository;
  final MissionsRepository missionsRepository;

  ObtainMarkerUseCase({
    required this.markerRepository,
    required this.userRepository,
    required this.userNoticesRepository,
    required this.obtainHistoryRepository,
    required this.missionsRepository,
    required this.rewardRepository,
  });

  @override
  Future<FortuneResult<MarkerObtainEntity>> call(RequestObtainMarkerParam param) async {
    try {
      final ingredient = param.marker.ingredient;
      final prevUser = await userRepository.findUserByPhone();
      final marker = await markerRepository.findMarkerById(param.marker.id);

      // 유저의 티켓이 없고, 리워드 티켓이 감소 일 경우.
      if (prevUser.ticket <= 0 && marker.ingredient.rewardTicket < 0) {
        throw CommonFailure(errorMessage: '보유한 티켓이 없습니다');
      }

      int updatedTicket = prevUser.ticket;
      int markerObtainCount = prevUser.markerObtainCount;

      // 티켓 및 획득 카운트 업데이트.
      updatedTicket = prevUser.ticket + ingredient.rewardTicket;
      markerObtainCount = markerObtainCount + 1;

      // 사용자 티켓 정보 업데이트.
      final updateUser = await userRepository.updateUser(
        prevUser.copyWith(
          // 타이밍 이슈 때문에 1개 더 먹을 수 있음.
          ticket: updatedTicket < 0 ? 0 : updatedTicket,
          markerObtainCount: markerObtainCount,
        ),
      );

      // 다이얼로그 타이틀.
      final dialogHeadings = () {
        if (prevUser.grade.name != updateUser.grade.name) {
          return "등급 업을 축하합니다!!";
        } else if (prevUser.level != updateUser.level) {
          return "레벨 업을 축하합니다";
        } else {
          return '';
        }
      }();

      // 다이얼로그 내용.
      final dialogContent = () {
        if (prevUser.grade.name != updateUser.grade.name) {
          return "${prevUser.grade.name} > ${updateUser.grade.name}";
        } else if (prevUser.level != updateUser.level) {
          return "${prevUser.level} > ${updateUser.level}";
        } else {
          return '';
        }
      }();

      // 레벨업 혹은 등급 업을 했을 경우.
      if (prevUser.level != updateUser.level) {
        // #1 이벤트 타입에 따른 보상 정보를 찾음.
        // final reward = await rewardRepository.insertRewardHistory(
        //   user: prevUser,
        //   type: EventRewardType.level,
        // );
        // await userNoticesRepository.insertNotice(
        //   RequestEventNotices.insert(
        //     users: prevUser.id,
        //     type: EventNoticeType.user.name,
        //     headings: dialogHeadings,
        //     content: dialogContent,
        //     eventRewards: reward.id,
        //     isRead: false,
        //     isReceived: false,
        //   ),
        // );
      }

      // 마커 재배치.
      await markerRepository.reLocateMarker(
        marker: marker,
        user: prevUser,
      );

      // 히스토리 추가.
      if (marker.ingredient.type != IngredientType.ticket) {
        await obtainHistoryRepository
            .insertObtainHistory(
          request: RequestObtainHistory.insert(
            userId: prevUser.id,
            markerId: marker.id,
            ingredientId: marker.ingredient.id,
            nickName: prevUser.nickname,
            krLocationName: param.kLocation,
            enLocationName: param.eLocation,
            ingredientName: param.marker.ingredient.name,
          ),
        )
            .then(
          (value) async {
            await _confirmRelayMissionClear(
              user: prevUser,
              markerId: marker.id,
            );
          },
        );
      }

      // 히스토리 수.
      final histories = await obtainHistoryRepository.getHistoriesByUser(userId: prevUser.id);

      return Right(
        MarkerObtainEntity(
          user: updateUser,
          dialogContent: dialogContent,
          dialogHeadings: dialogHeadings,
          isLevelOrGradeUp: dialogContent.isNotEmpty && dialogHeadings.isNotEmpty,
          haveCount: histories.length,
        ),
      );
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }

  _confirmRelayMissionClear({
    required FortuneUserEntity user,
    required int markerId,
  }) async {
    final mission = await missionsRepository.getMissionOrNullByMarkerId(markerId);
    if (mission != null) {
      // 미션 클리어 조건 들을 조회.
      final clearConditions = await missionsRepository.getMissionClearConditions(mission.id);
      // 미션 클리어 조건.
      final condition = clearConditions.firstWhereOrNull((element) => element.mission.id == mission.id);
      // 마커 조회.
      final markerEntity = await markerRepository.findMarkerById(markerId);
      // 클리어 조건. (내가 클리어 한 건지)
      final isClear = markerEntity.hitCount == condition?.requireCount && markerEntity.lastObtainUser == user.id;
      if (isClear) {
        // 미션 클리어.
        await missionsRepository.postMissionClear(missionId: mission.id);
        await userNoticesRepository.insertNotice(
          RequestEventNotices.insert(
            headings: '릴레이 미션을 클리 하셨습니다.',
            content: '릴레이 미션 클리어!!',
            type: EventNoticeType.user.name,
            users: user.id,
            isRead: false,
          ),
        );
      }
    }
  }
}
