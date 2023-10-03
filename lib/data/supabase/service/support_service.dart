import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/response/support/faqs_response.dart';
import 'package:fortune/data/supabase/response/support/notices_response.dart';
import 'package:fortune/data/supabase/response/support/privacy_policy_response.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/support/faq_entity.dart';
import 'package:fortune/domain/supabase/entity/support/notices_entity.dart';
import 'package:fortune/domain/supabase/entity/support/privacy_policy_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupportService {
  static const _faqsTableName = TableName.faqs;
  static const _noticesTableName = TableName.notices;
  static const _privacyPolicyTableName = TableName.privacyPolicy;

  static const fullSelectQuery = '*';

  final SupabaseClient _client = Supabase.instance.client;

  SupportService();

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

  // 개인정보처리방침
  Future<List<PrivacyPolicyEntity>> findPrivacyPolicy() async {
    try {
      final List<dynamic> response = await _client.from(_privacyPolicyTableName).select("*").toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final privacyPolicies = response.map((e) => PrivacyPolicyResponse.fromJson(e)).toList();
        return privacyPolicies;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
