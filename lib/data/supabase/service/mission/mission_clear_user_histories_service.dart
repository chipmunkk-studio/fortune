import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_mission_clear_user.dart';
import 'package:fortune/data/supabase/request/request_mission_clear_user_histories.dart';
import 'package:fortune/data/supabase/response/mission/mission_clear_user_histories_response.dart';
import 'package:fortune/data/supabase/service/mission/missions_service.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionClearUserHistoriesService {
  static const _tableName = TableName.missionClearUser;
  static const _tableHistoriesName = TableName.missionClearUserHistories;

  final SupabaseClient _client = Supabase.instance.client;

  static const _fullSelectQuery = '*,'
      '${TableName.users}(*),'
      '${TableName.missions}(${MissionsService.fullSelectQuery})';

  MissionClearUserHistoriesService();

  // 미션을 클리어한 유저들 모두 조회.
  Future<List<MissionClearUserHistoriesEntity>> findAllMissionClearUsers({
    required int start,
    required int end,
  }) async {
    try {
      final response = await _client
          .from(_tableHistoriesName)
          .select(
            _fullSelectQuery,
          )
          .order('created_at', ascending: false)
          .range(start, end)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final users = response.map((e) => MissionClearUserHistoriesResponse.fromJson(e)).toList();
        return users;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 아이디로 미션 클리어한 유저 조회.
  Future<MissionClearUserHistoriesEntity> findAllMissionClearUserById(int id) async {
    try {
      final response = await _client.from(_tableHistoriesName).select(_fullSelectQuery).eq('id', id).toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '미션클리어 사용자가 존재하지 않습니다.');
      } else {
        final users = response.map((e) => MissionClearUserHistoriesResponse.fromJson(e)).toList();
        return users.single;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 미션 클리어 사용자 추가.
  Future<void> insert(
    RequestMissionClearUser request,
  ) async {
    try {
      // 미션 클리어 히스토리 테이블에 또 한번 저장.
      // 클리어 유저랑 별도로 히스토리 관리용으로 생성.
      await _client
          .from(_tableHistoriesName)
          .insert(
            RequestMissionClearUserHistories(
              mission: request.mission,
              user: request.user,
            ),
          )
          .select(_fullSelectQuery);
      final insertUser = await _client
          .from(_tableName)
          .insert(
            request.toJson(),
          )
          .select(_fullSelectQuery);
      return insertUser.map((e) => MissionClearUserHistoriesResponse.fromJson(e)).toList().single;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
