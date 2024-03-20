import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/service/support_service.dart';
import 'package:fortune/domain/supabase/entity/support/app_update_entity.dart';
import 'package:fortune/domain/supabase/entity/support/faq_entity.dart';
import 'package:fortune/domain/supabase/entity/support/notices_entity.dart';
import 'package:fortune/domain/supabase/entity/support/privacy_policy_entity.dart';
import 'package:fortune/domain/supabase/repository/support_repository.dart';

class SupportRepositoryImpl extends SupportRepository {
  final SupportService supportService;

  SupportRepositoryImpl({
    required this.supportService,
  });

  @override
  Future<List<FaqsEntity>> getFaqs({bool onlyCount = false}) async {
    try {
      List<FaqsEntity> faqs = onlyCount ? await supportService.findAllFaqCount() : await supportService.findAllFaqs();
      return faqs;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<List<NoticesEntity>> getNotices({bool onlyCount = false}) async {
    try {
      List<NoticesEntity> notices =
          onlyCount ? await supportService.findAllNoticesCount() : await supportService.findAllNotices();
      return notices;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<List<PrivacyPolicyEntity>> getPrivacyPolicy() async {
    try {
      List<PrivacyPolicyEntity> privacy = await supportService.findPrivacyPolicy();
      return privacy;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<List<AppUpdateEntity>> getAppUpdateRecently() async {
    try {
      List<AppUpdateEntity> update = await supportService.findAllAppUpdate();
      return update;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }
}
