import 'package:fortune/domain/supabase/entity/support/faq_entity.dart';
import 'package:fortune/domain/supabase/entity/support/notices_entity.dart';
import 'package:fortune/domain/supabase/entity/support/privacy_policy_entity.dart';

abstract class SupportRepository {
  Future<List<NoticesEntity>> getNotices();

  Future<List<FaqsEntity>> getFaqs();

  Future<List<PrivacyPolicyEntity>> getPrivacyPolicy();
}
