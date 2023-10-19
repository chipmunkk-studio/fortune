class NoticesEntity {
  final String title;
  final String content;
  final String createdAt;
  final bool isNew;

  NoticesEntity({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.isNew,
  });
}
