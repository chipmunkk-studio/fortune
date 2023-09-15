import 'package:foresh_flutter/domain/supabase/entity/common/faq_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/common/notices_entity.dart';

abstract class SupportRepository {
  Future<List<NoticesEntity>> getNotices();

  Future<List<FaqsEntity>> getFaqs();
}
