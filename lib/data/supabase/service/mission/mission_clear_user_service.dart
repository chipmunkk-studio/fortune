import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_mission_clear_user.dart';
import 'package:fortune/data/supabase/response/mission/mission_clear_user_response.dart';
import 'package:fortune/data/supabase/service/mission/missions_service.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionClearUserService {
  static const _normalMissionClearUserTableName = "mission_clear_user";

  final SupabaseClient _client;
  static const _fullSelectQuery = '*,'
      '${TableName.users}(*),'
      '${TableName.missions}(${MissionsService.fullSelectQuery})';

  MissionClearUserService(this._client);

  // 미션을 클리어한 유저들 모두 조회.
  Future<List<MissionClearUserEntity>> findAllMissionClearUsers() async {
    try {
      final response = await _client.from(_normalMissionClearUserTableName).select(_fullSelectQuery).toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final users = response.map((e) => MissionClearUserResponse.fromJson(e)).toList();
        return users;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 아이디로 미션 클리어한 유저 조회.
  Future<MissionClearUserEntity> findAllMissionClearUserById(int id) async {
    try {
      final response =
          await _client.from(_normalMissionClearUserTableName).select(_fullSelectQuery).eq('id', id).toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '미션클리어 사용자가 존재하지 않습니다.');
      } else {
        final users = response.map((e) => MissionClearUserResponse.fromJson(e)).toList();
        return users.single;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 미션 클리어 사용자 업데이트.
  Future<MissionClearUserEntity> update(
    int id, {
    required RequestMissionClearUser request,
  }) async {
    try {
      MissionClearUserEntity clearUser = await findAllMissionClearUserById(id);

      final requestToUpdate = RequestMissionClearUser(
        mission: request.mission ?? clearUser.mission.id,
        user: request.user ?? clearUser.user.id,
        isReceive: request.isReceive ?? clearUser.isReceive,
      );

      final updateUser = await _client
          .from(_normalMissionClearUserTableName)
          .update(requestToUpdate.toJson())
          .eq('id', id)
          .select(_fullSelectQuery);

      return updateUser.map((e) => MissionClearUserResponse.fromJson(e)).toList().single;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 미션 클리어 사용자 추가.
  Future<void> insert(
    RequestMissionClearUser request,
  ) async {
    try {
      final insertUser = await _client
          .from(_normalMissionClearUserTableName)
          .insert(
            request.toJson(),
          )
          .select(_fullSelectQuery);
      return insertUser.map((e) => MissionClearUserResponse.fromJson(e)).toList().single;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
