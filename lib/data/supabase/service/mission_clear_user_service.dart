import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_mission_clear_user_update.dart';
import 'package:foresh_flutter/data/supabase/response/mission_clear_user_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_clear_user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionClearUserService {
  static const _missionClearUserTableName = "mission_clear_user";

  final SupabaseClient _client;

  MissionClearUserService(this._client);

  // 미션을 클리어한 유저들 모두 조회.
  Future<List<MissionClearUserEntity>> findAllMissionClearUsers() async {
    try {
      final response = await _client.from(_missionClearUserTableName).select("*,mission(*),user(*)").toSelect();
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
          await _client.from(_missionClearUserTableName).select("*,mission(*),user(*)").eq('id', id).toSelect();
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

  // 미션 클리어 사용자 업데이트 및 가져오기
  Future<MissionClearUserEntity> update(
    int id, {
    String? email,
    bool? isReceived,
  }) async {
    try {
      MissionClearUserEntity? user = await findAllMissionClearUserById(id);
      if (user != null) {
        final updateUser = await _client
            .from(_missionClearUserTableName)
            .update(
              RequestMissionClearUserUpdate(
                email: email ?? user.email,
                isReceived: isReceived ?? user.isReceive,
              ).toJson(),
            )
            .eq('id', id)
            .select('*,user(*),mission(*)');
        return updateUser.map((e) => MissionClearUserResponse.fromJson(e)).toList().single;
      } else {
        throw const PostgrestException(message: '사용자가 존재하지 않습니다');
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
