import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/response/alarmfeed/alarm_reward_info_response.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlarmRewardInfoService {
  static const fullSelectQuery = '*';

  final _tableName = TableName.alarmRewardInfo;

  final SupabaseClient _client = Supabase.instance.client;

  AlarmRewardInfoService();

  // 리워드 타입으로 리워드 정보 검색 검색.
  Future<AlarmRewardInfoEntity> findEventRewardsByType(String type) async {
    try {
      final response = await _client
          .from(_tableName)
          .select(
            fullSelectQuery,
          )
          .filter('type', 'eq', type)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '등록된 리워드 정보가 없습니다');
      } else {
        final reward = response.map((e) => AlarmRewardInfoResponse.fromJson(e)).toList().single;
        return reward;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
