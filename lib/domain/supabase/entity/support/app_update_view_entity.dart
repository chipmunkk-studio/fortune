class AppUpdateViewEntity {
  final String title;
  final String content;
  final bool isActive;
  final bool isForceUpdate;
  final bool isAlert;

  AppUpdateViewEntity({
    required this.title,
    required this.content,
    required this.isActive,
    required this.isForceUpdate,
    required this.isAlert,
  });
}
