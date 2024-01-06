import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/response/support/app_update_response.dart';
import 'package:fortune/data/supabase/response/support/faqs_response.dart';
import 'package:fortune/data/supabase/response/support/notices_response.dart';
import 'package:fortune/data/supabase/response/support/privacy_policy_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/support/app_update_entity.dart';
import 'package:fortune/domain/supabase/entity/support/faq_entity.dart';
import 'package:fortune/domain/supabase/entity/support/notices_entity.dart';
import 'package:fortune/domain/supabase/entity/support/privacy_policy_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupportService {
  static const _faqsTableName = TableName.faqs;
  static const _noticesTableName = TableName.notices;
  static const _privacyPolicyTableName = TableName.privacyPolicy;
  static const _appUpdateTableName = TableName.appUpdate;

  static const fullSelectQuery = '*';

  final SupabaseClient _client = Supabase.instance.client;

  SupportService();

  // 자주 묻는 질문.
  Future<List<FaqsEntity>> findAllFaqs() async {
    try {
      final List<dynamic> response = await _client
          .from(_faqsTableName)
          .select("*")
          .order(
            'created_at',
            ascending: false,
          )
          .toSelect();
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

  Future<List<FaqsEntity>> findAllFaqCount() async {
    try {
      final response = await _client
          .from(
            _faqsTableName,
          )
          .select(
            'created_at',
          );

      if (response.isEmpty) {
        return List.empty();
      }

      return response.map((e) => FaqsResponse.fromJson(e)).toList();
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 공지 사항.
  Future<List<NoticesEntity>> findAllNotices() async {
    try {
      final List<dynamic> response = await _client
          .from(_noticesTableName)
          .select("*")
          .order('is_pin', ascending: false)
          .order('created_at', ascending: false)
          .toSelect();
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

  Future<List<NoticesEntity>> findAllNoticesCount() async {
    try {
      final response = await _client
          .from(
            _noticesTableName,
          )
          .select(
            'created_at',
          );

      if (response.isEmpty) {
        return List.empty();
      }

      return response.map((e) => NoticesResponse.fromJson(e)).toList();
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  Future<List<AppUpdateEntity>> findAllAppUpdate() async {
    try {
      final response = await _client
          .from(_appUpdateTableName)
          .select("*")
          .filter('is_active', 'eq', true)
          .order(
            'created_at',
            ascending: false,
          )
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final faqs = response.map((e) => AppUpdateResponse.fromJson(e)).toList();
        return faqs;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 개인정보처리방침
  Future<List<PrivacyPolicyEntity>> findPrivacyPolicy() async {
    try {
      final List<dynamic> response = await _client
          .from(_privacyPolicyTableName)
          .select("*")
          .order(
            'created_at',
            ascending: false,
          )
          .toSelect();
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
