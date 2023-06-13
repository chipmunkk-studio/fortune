import 'dart:math';

import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_marker_random_insert.dart';
import 'package:foresh_flutter/data/supabase/request/request_marker_update.dart';
import 'package:foresh_flutter/data/supabase/response/marker_response.dart';
import 'package:foresh_flutter/data/supabase/response/mission_clear_condition_response.dart';
import 'package:foresh_flutter/data/supabase/response/mission_clear_history_response.dart';
import 'package:foresh_flutter/data/supabase/response/mission_clear_user_response.dart';
import 'package:foresh_flutter/data/supabase/response/mission_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_clear_condition_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_clear_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_clear_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_entity.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionService {
  static const _missionsTableName = "missions";
  static const _missionClearConditionTableName = "mission_clear_conditions";
  static const _missionClearUserTableName = "mission_clear_user";
  static const _missionClearHistoryTableName = "mission_clear_history";

  final SupabaseClient _client;

  MissionService(this._client);

  // 모든 미션을 조회.
  Future<List<MissionEntity>> findAllMissions() async {
    try {
      final response = await _client.from(_missionsTableName).select("*").toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final missions = response.map((e) => MissionResponse.fromJson(e)).toList();
        return missions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

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

  // 미션 아이디로 클리어 조건을 조회.
  Future<List<MissionClearConditionEntity>> findMissionClearConditionByMissionId(int id) async {
    try {
      final response = await _client.from(_missionClearConditionTableName).select("*,ingredient(*),mission(*)").eq('mission', id).toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final missionClearConditions = response.map((e) => MissionClearConditionResponse.fromJson(e)).toList();
        return missionClearConditions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 유저 아이디로 미션 클리어 히스토리 조회.
  Future<List<MissionClearHistoryEntity>> findAllMissionClearHistoryById(int id) async {
    try {
      final response = await _client.from(_missionClearHistoryTableName).select("*").eq('user_id', id).toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final missionClearHistories = response.map((e) => MissionClearHistoryResponse.fromJson(e)).toList();
        return missionClearHistories;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
