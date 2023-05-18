import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/common/announcement_entity.dart';
import 'package:foresh_flutter/domain/entities/common/faq_entity.dart';

abstract class CommonRepository {
  Future<FortuneResult<AnnouncementEntity>> getAnnouncement(int page);

  Future<FortuneResult<FaqEntity>> getFaq(int page);
}
