class NoticesEntity {
  final String title;
  final String content;
  final String createdAt;
  final bool isNew;
  final bool isPin;

  NoticesEntity({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.isNew,
    required this.isPin,
  });
}
