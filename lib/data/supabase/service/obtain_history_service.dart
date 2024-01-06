import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_obtain_history.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/response/ingredient_response.dart';
import 'package:fortune/data/supabase/response/obtain_history_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ObtainHistoryService {
  static const _obtainHistoryTableName = "obtain_histories";
  final SupabaseClient _client = Supabase.instance.client;

  ObtainHistoryService();

  Future<List<ObtainHistoryResponse>> findObtainHistories({
    required int start,
    required int end,
    required String query,
  }) async {
    try {
      final columnsToSelect = [
        ObtainHistoryColumn.createdAt,
        ObtainHistoryColumn.nickName,
        ObtainHistoryColumn.locationName,
        ObtainHistoryColumn.krIngredientName,
        ObtainHistoryColumn.enIngredientName,
        ObtainHistoryColumn.ingredient,
        ObtainHistoryColumn.users,
      ];

      final selectColumns = columnsToSelect.map((column) {
        if (column == ObtainHistoryColumn.ingredient) {
          return '${ObtainHistoryColumn.ingredient.name}('
              '${IngredientColumn.imageUrl.name}(*)'
              ')';
        } else if (column == ObtainHistoryColumn.users) {
          return '${TableName.users}(${UserColumn.nickname.name})';
        }
        return column.name;
      }).toList();

      final convertedQuery = '%$query%';
      final List<dynamic> response = await _client
          .from(_obtainHistoryTableName)
          .select(selectColumns.join(","))
          .or(
            '${ObtainHistoryColumn.locationName.name}.ilike.$convertedQuery, '
            '${ObtainHistoryColumn.krIngredientName.name}.ilike.$convertedQuery, '
            '${ObtainHistoryColumn.enIngredientName.name}.ilike.$convertedQuery, '
            '${ObtainHistoryColumn.markerId.name}.ilike.$convertedQuery, '
            '${ObtainHistoryColumn.nickName.name}.ilike.$convertedQuery',
          )
          .filter(ObtainHistoryColumn.isReward.name, 'eq', false)
          .order(ObtainHistoryColumn.createdAt.name, ascending: false)
          .range(start, end)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final histories = response.map((e) => ObtainHistoryResponse.fromJson(e)).toList();
        return histories;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  Future<List<ObtainHistoryResponse>> findObtainHistoryByUserAndIngredient({
    required int userId,
    required int ingredientId,
  }) async {
    final columnsToSelect = [
      ObtainHistoryColumn.ingredient,
      ObtainHistoryColumn.createdAt,
    ];

    final selectColumns = columnsToSelect.map((column) {
      if (column == ObtainHistoryColumn.ingredient) {
        return '${ObtainHistoryColumn.ingredient.name}('
            '${IngredientColumn.id.name},'
            '${IngredientColumn.imageUrl.name}(*)'
            ')';
      }
      return column.name;
    }).toList();

    try {
      final List<dynamic> response = await _client
          .from(_obtainHistoryTableName)
          .select(selectColumns.join(","))
          .eq(ObtainHistoryColumn.users.name, userId)
          .eq(ObtainHistoryColumn.ingredient.name, ingredientId)
          .order(ObtainHistoryColumn.createdAt.name, ascending: false)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final histories = response.map((e) => ObtainHistoryResponse.fromJson(e)).toList();
        return histories;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  Future<List<ObtainHistoryResponse>> findObtainHistoryByUser(
    userId, {
    required List<ObtainHistoryColumn> columnsToSelect,
  }) async {
    final selectColumns = columnsToSelect.map((column) {
      if (column == ObtainHistoryColumn.ingredient) {
        return '${ObtainHistoryColumn.ingredient.name}('
            '${IngredientColumn.id.name},'
            '${IngredientColumn.imageUrl.name},'
            '${IngredientColumn.krName.name},'
            '${IngredientColumn.enName.name},'
            '${IngredientColumn.rewardTicket.name},'
            '${IngredientColumn.type.name},'
            '${IngredientColumn.imageUrl.name}(*)'
            ')';
      }
      return column.name;
    }).toList();

    try {
      final List<dynamic> response = await _client
          .from(_obtainHistoryTableName)
          .select(selectColumns.join(","))
          .eq(
            ObtainHistoryColumn.users.name,
            userId,
          )
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final histories = response.map((e) => ObtainHistoryResponse.fromJson(e)).toList();
        return histories;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 마커 히스토리 삽입.
  Future<void> insert({required RequestObtainHistory request}) async {
    try {
      await _client.from(_obtainHistoryTableName).insert(request.toJson());
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 히스토리 삭제.
  Future<void> delete(List<int> list) async {
    try {
      await _client.from(_obtainHistoryTableName).delete().inFilter('id', list);
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
