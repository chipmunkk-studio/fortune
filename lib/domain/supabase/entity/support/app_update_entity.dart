class AppUpdateEntity {
  final String title;
  final String content;
  final bool isActive;
  final bool android;
  final bool ios;
  final String createdAt;

  AppUpdateEntity({
    required this.title,
    required this.content,
    required this.isActive,
    required this.android,
    required this.ios,
    required this.createdAt,
  });
}
