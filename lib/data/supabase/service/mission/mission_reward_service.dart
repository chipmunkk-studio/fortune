import 'package:foresh_flutter/core/error/failure/common_failure.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_mission_reward_update.dart';
import 'package:foresh_flutter/data/supabase/response/mission/mission_reward_response.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/data/supabase/supabase_ext.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionRewardService {
  static const fullSelectQuery = '*';

  final SupabaseClient _client = Supabase.instance.client;

  MissionRewardService();

  // 아이디로 미션 리워드를 조회.
  Future<MissionRewardResponse> findMissionRewardById(int id) async {
    try {
      final response =
          await _client.from(TableName.missionReward).select(fullSelectQuery).filter('id', 'eq', id).toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '리워드가 존재하지 않습니다');
      } else {
        final missions = response.map((e) => MissionRewardResponse.fromJson(e)).toList();
        return missions.single;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 미션 리워드 업데이트.
  Future<MissionRewardResponse> update(
    int id, {
    required RequestMissionRewardUpdate request,
  }) async {
    try {
      MissionRewardResponse missionReward = await findMissionRewardById(id);

      final requestToUpdate = RequestMissionRewardUpdate(
        totalCount: request.totalCount ?? missionReward.totalCount_,
        rewardName: request.rewardName ?? missionReward.rewardName_,
        remainCount: request.remainCount ?? missionReward.remainCount_,
        rewardImage: request.rewardImage ?? missionReward.rewardImage_,
      );

      final updateMission = await _client
          .from(TableName.missionReward)
          .update(
            requestToUpdate.toJson(),
          )
          .eq('id', id)
          .select(fullSelectQuery);
      return updateMission.map((e) => MissionRewardResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
