class AnnouncementEntity {
  final List<NoticeEntity> notices;

  AnnouncementEntity({required this.notices});
}

abstract class AnnouncementContentParentEntity {}

class NoticeEntity extends AnnouncementContentParentEntity {
  final String title;
  final String content;
  final String createdAt;
  final bool isNew;

  NoticeEntity({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.isNew,
  });
}

class AnnouncementContentNextPageLoading extends AnnouncementContentParentEntity {}
