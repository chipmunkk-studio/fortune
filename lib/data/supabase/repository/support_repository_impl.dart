import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/service/support_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/common/faq_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/common/notices_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/support_repository.dart';

class SupportRepositoryImpl extends SupportRepository {
  final SupportService supportService;

  SupportRepositoryImpl({
    required this.supportService,
  });

  @override
  Future<List<FaqsEntity>> getFaqs() async {
    try {
      List<FaqsEntity> faqs = await supportService.findAllFaqs();
      return faqs;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }

  @override
  Future<List<NoticesEntity>> getNotices() async {
    try {
      List<NoticesEntity> notices = await supportService.findAllNotices();
      return notices;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.description}',
      );
    }
  }
}
