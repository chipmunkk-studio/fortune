import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/response/common/faqs_response.dart';
import 'package:fortune/data/supabase/response/common/notices_response.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/domain/supabase/entity/common/faq_entity.dart';
import 'package:fortune/domain/supabase/entity/common/notices_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupportService {
  static const _faqsTableName = "faqs";
  static const _noticesTableName = "notices";

  static const fullSelectQuery = '*';

  final SupabaseClient _client;

  SupportService(
    this._client,
  );

  // 자주 묻는 질문.
  Future<List<FaqsEntity>> findAllFaqs() async {
    try {
      final List<dynamic> response = await _client.from(_faqsTableName).select("*").toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final faqs = response.map((e) => FaqsResponse.fromJson(e)).toList();
        return faqs;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 공지 사항.
  Future<List<NoticesEntity>> findAllNotices() async {
    try {
      final List<dynamic> response = await _client.from(_noticesTableName).select("*").toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final faqs = response.map((e) => NoticesResponse.fromJson(e)).toList();
        return faqs;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
