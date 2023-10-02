import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/response/country_info_response.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/country_info_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CountryInfoService {
  final _countryInfoTableName = TableName.countryInfo;

  static const fullSelectQuery = '*';

  final SupabaseClient _client = Supabase.instance.client;

  CountryInfoService();

  // 모든 국가 정보 불러오기.
  Future<List<CountryInfoEntity>> findAllCountryInfo() async {
    try {
      final List<dynamic> response = await _client
          .from(
            _countryInfoTableName,
          )
          .select("*")
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final faqs = response.map((e) => CountryInfoResponse.fromJson(e)).toList();
        return faqs;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
