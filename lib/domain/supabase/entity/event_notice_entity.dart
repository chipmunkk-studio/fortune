class EventNoticeEntity {
  final int id;
  final String title;
  final String content;
  final String searchText;
  final String type;
  final double ticket;
  final String landingRoute;
  final String createdAt;

  EventNoticeEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.searchText,
    required this.type,
    required this.ticket,
    required this.landingRoute,
    required this.createdAt,
  });
}
