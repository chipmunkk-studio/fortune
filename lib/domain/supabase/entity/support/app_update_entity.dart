class AppUpdateEntity {
  final String title;
  final String content;
  final bool isActive;
  final bool android;
  final bool ios;
  final String createdAt;
  final String minVersion;
  final String landingRoute;
  final int minVersionCode;
  final bool isAlert;

  AppUpdateEntity({
    required this.title,
    required this.content,
    required this.isActive,
    required this.android,
    required this.ios,
    required this.createdAt,
    required this.minVersion,
    required this.minVersionCode,
    required this.isAlert,
    required this.landingRoute,
  });
}
