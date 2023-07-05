class EventNoticeEntity {
  final int id;
  final String searchText;
  final String type;
  final int ticket;
  final String landingRoute;
  final String createdAt;

  EventNoticeEntity({
    required this.id,
    required this.searchText,
    required this.type,
    required this.ticket,
    required this.landingRoute,
    required this.createdAt,
  });
}
