import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_mission_clear_user.dart';
import 'package:fortune/data/supabase/request/request_mission_clear_user_histories.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/response/mission/mission_clear_user_histories_response.dart';
import 'package:fortune/data/supabase/response/mission/mission_reward_response.dart';
import 'package:fortune/data/supabase/response/mission/missions_response.dart';
import 'package:fortune/data/supabase/service/mission/missions_service.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionClearUserHistoriesService {
  static const _tableClearUserName = TableName.missionClearUser;
  static const _tableClearUserHistoriesName = TableName.missionClearUserHistories;

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
    // 조회 해야 할 컬럼.
    final columnsToSelect = [
      MissionClearUserHistoriesColumn.users,
      MissionClearUserHistoriesColumn.missions,
      MissionClearUserHistoriesColumn.createdAt,
    ];

    final selectColumns = columnsToSelect.map((column) {
      if (column == MissionClearUserHistoriesColumn.users) {
        return '${TableName.users}('
            '${UserColumn.nickname.name},'
            '${UserColumn.profileImage.name}'
            ')';
      } else if (column == MissionClearUserHistoriesColumn.missions) {
        return '${TableName.missions}('
            '${MissionsColumn.krTitle.name},'
            '${MissionsColumn.enTitle.name}'
            ')';
      }
      return column.name;
    }).toList();
    try {
      final response = await _client
          .from(_tableClearUserHistoriesName)
          .select(selectColumns.join(","))
          .order(MissionClearUserHistoriesColumn.createdAt.name, ascending: false)
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

  Future<List<MissionClearUserHistoriesEntity>> findAllMissionClearUserByUserId(int userId) async {
    try {
      // 조회 해야 할 컬럼.
      final columnsToSelect = [
        MissionClearUserHistoriesColumn.users,
        MissionClearUserHistoriesColumn.missions,
        MissionClearUserHistoriesColumn.createdAt,
      ];

      final selectColumns = columnsToSelect.map((column) {
        if (column == MissionClearUserHistoriesColumn.users) {
          return '${TableName.users}('
              '${UserColumn.nickname.name},'
              '${UserColumn.profileImage.name}'
              ')';
        } else if (column == MissionClearUserHistoriesColumn.missions) {
          // 리워드 컬럼.
          final rewardColumn = "${TableName.missionReward}("
              "${MissionRewardColumn.rewardImage.name},"
              "${MissionRewardColumn.enRewardName.name},"
              "${MissionRewardColumn.krRewardName.name},"
              "${MissionRewardColumn.createdAt.name}"
              ")";

          return "${TableName.missions}("
              '${MissionsColumn.krTitle.name},'
              '${MissionsColumn.enTitle.name},'
              '$rewardColumn'
              ")";
        }
        return column.name;
      }).toList();

      final response = await _client
          .from(_tableClearUserHistoriesName)
          .select(selectColumns.join(","))
          .filter(TableName.users, 'eq', userId)
          .order(MissionClearUserHistoriesColumn.createdAt.name, ascending: false)
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

  // 미션 클리어 사용자 추가.
  Future<MissionClearUserHistoriesResponse> insert(
    RequestMissionClearUser request,
  ) async {
    try {
      // 미션 클리어 히스토리 테이블에 또 한번 저장.
      // 클리어 유저랑 별도로 히스토리 관리용으로 생성.
      await _client
          .from(_tableClearUserHistoriesName)
          .insert(
            RequestMissionClearUserHistories(
              mission: request.mission,
              user: request.user,
            ),
          )
          .select(_fullSelectQuery);
      final insertUser = await _client
          .from(_tableClearUserName)
          .insert(
            request.toJson(),
          )
          .select(_fullSelectQuery);
      return insertUser.map((e) => MissionClearUserHistoriesResponse.fromJson(e)).toList().single;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 사용자 미션 클리어 랭킹 조회.
  Future<Map<String, int>> findAllMissionClearCountsByRanking() async {
    try {
      final response = await _client
          .from(_tableClearUserHistoriesName)
          .select(
            _getSelectColumns(
              [
                MissionClearUserHistoriesColumn.users,
              ],
            ),
          )
          .toSelect();

      final countIdMap = <String, int>{};
      final users = response.map((e) => MissionClearUserHistoriesResponse.fromJson(e)).toList();

      for (var record in users) {
        countIdMap[record.user.email] = (countIdMap[record.user.email] ?? 0) + 1;
      }

      return countIdMap;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  String _getSelectColumns(List<MissionClearUserHistoriesColumn> columns) {
    final columnsList = columns.map((column) {
      if (column == MissionClearUserHistoriesColumn.users) {
        return '${TableName.users}('
            '${UserColumn.email.name},'
            '${UserColumn.nickname.name},'
            '${UserColumn.level.name},'
            '${UserColumn.markerObtainCount.name},'
            '${UserColumn.profileImage.name}'
            ')';
      } else if (column == MissionClearUserHistoriesColumn.missions) {
        // 리워드 컬럼.
        final rewardColumn = "${TableName.missionReward}("
            "${MissionRewardColumn.rewardImage.name},"
            "${MissionRewardColumn.enRewardName.name},"
            "${MissionRewardColumn.krRewardName.name},"
            "${MissionRewardColumn.createdAt.name}"
            ")";

        return "${TableName.missions}("
            '${MissionsColumn.krTitle.name},'
            '${MissionsColumn.enTitle.name},'
            '$rewardColumn'
            ")";
      }
      return column.name;
    }).toList();
    return columnsList.join(',');
  }
}
