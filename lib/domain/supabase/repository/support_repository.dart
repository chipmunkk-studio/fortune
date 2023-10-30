import 'package:fortune/domain/supabase/entity/support/app_update_entity.dart';
import 'package:fortune/domain/supabase/entity/support/faq_entity.dart';
import 'package:fortune/domain/supabase/entity/support/notices_entity.dart';
import 'package:fortune/domain/supabase/entity/support/privacy_policy_entity.dart';

abstract class SupportRepository {
  Future<List<NoticesEntity>> getNotices({bool onlyCount = false});

  Future<List<FaqsEntity>> getFaqs({bool onlyCount = false});

  Future<List<PrivacyPolicyEntity>> getPrivacyPolicy();

  Future<List<AppUpdateEntity>> getAppUpdateRecently();
}
