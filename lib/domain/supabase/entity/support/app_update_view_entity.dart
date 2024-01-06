class AppUpdateViewEntity {
  final String title;
  final String content;
  final String landingRoute;
  final bool isActive;
  final bool isForceUpdate;
  final bool isAlert;

  AppUpdateViewEntity({
    required this.title,
    required this.content,
    required this.landingRoute,
    required this.isActive,
    required this.isForceUpdate,
    required this.isAlert,
  });

  static AppUpdateViewEntity get empty => AppUpdateViewEntity(
    title: '',
    content: '',
    isActive: false,
    isForceUpdate: false,
    landingRoute: '',
    isAlert: false,
  );
}
