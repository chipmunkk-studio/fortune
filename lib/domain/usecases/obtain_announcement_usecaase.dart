import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/common/announcement_entity.dart';
import 'package:foresh_flutter/domain/repositories/common_repository.dart';

class ObtainAnnouncementUseCase implements UseCase1<AnnouncementEntity, int> {
  final CommonRepository repository;

  ObtainAnnouncementUseCase(this.repository);

  @override
  Future<FortuneResult<AnnouncementEntity>> call(int page) async {
    return await repository.getAnnouncement(page);
  }
}
