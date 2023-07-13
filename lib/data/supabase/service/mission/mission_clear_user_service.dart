import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_mission_clear_user_update.dart';
import 'package:foresh_flutter/data/supabase/response/mission/mission_clear_user_response.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_clear_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionClearUserService {
  static const _normalMissionClearUserTableName = "mission_clear_user";

  final SupabaseClient _client;
  static const _fullSelectQuery = '*,user(*),mission(*,marker(*,ingredient(*)))';

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
  Future<MissionClearUserEntity?> findAllMissionClearUserById(int id) async {
    try {
      final response =
          await _client.from(_normalMissionClearUserTableName).select(_fullSelectQuery).eq('id', id).toSelect();
      if (response.isEmpty) {
        return null;
      } else {
        final users = response.map((e) => MissionClearUserResponse.fromJson(e)).toList();
        return users.singleOrNull;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 미션 클리어 사용자 업데이트.
  Future<MissionClearUserEntity> update(
    int id, {
    String? email,
    bool? isReceived,
  }) async {
    try {
      MissionClearUserEntity? clearUser = await findAllMissionClearUserById(id);
      if (clearUser != null) {
        final updateUser = await _client
            .from(_normalMissionClearUserTableName)
            .upsert(
              RequestMissionClearUserUpdate(
                missionId: clearUser.mission.id,
                userId: clearUser.user.id,
                email: email ?? clearUser.email,
                isReceived: isReceived ?? clearUser.isReceive,
              ).toJson(),
            )
            .eq('id', id)
            .select(_fullSelectQuery);
        return updateUser.map((e) => MissionClearUserResponse.fromJson(e)).toList().single;
      } else {
        throw const PostgrestException(message: '사용자가 존재하지 않습니다');
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 미션 클리어 사용자 추가.
  Future<void> insert({
    required String email,
    required int missionId,
    required int userId,
  }) async {
    try {
      final insertUser = await _client
          .from(_normalMissionClearUserTableName)
          .insert(
            RequestMissionClearUserUpdate(
              missionId: missionId,
              userId: userId,
              isReceived: false,
              email: email,
            ).toJson(),
          )
          .select(_fullSelectQuery);
      return insertUser.map((e) => MissionClearUserResponse.fromJson(e)).toList().single;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
