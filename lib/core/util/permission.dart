import 'package:permission_handler/permission_handler.dart';

abstract class FortunePermissionUtil {
  // 안드로이드 요청 권한.
  static final androidPermissions = [
    // Permission.storage,
    Permission.location,
  ];

  // ios 요청 권한.
  static final iosPermissions = [
    // Permission.photos,
    Permission.location,
  ];

  /// 권한 요청.
  /// - 모든 권한을 한꺼번에 요청하고, 하나라도 거부될 경우 false를 리턴 함.
  static Future<bool> requestPermission(List<Permission> permissions) async {
    bool isGranted = true;

    Map<Permission, PermissionStatus> statuses = await permissions.request();
    statuses.forEach((key, value) {
      if (!value.isGranted) {
        isGranted = false;
      }
    });
    return isGranted;
  }

  static Future<bool> checkPermissionsStatus(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = {};

    for (var permission in permissions) {
      statuses[permission] = await permission.status;
    }

    bool isAnyPermissionDenied = statuses.values.any((status) => status.isDenied);

    return isAnyPermissionDenied;
  }

  static _getVerifyCode(String? sms) {
    final intRegex = RegExp(r'\d+', multiLine: true);
    if (sms != null) {
      return intRegex.allMatches(sms).first.group(0);
    } else {
      return "";
    }
  }
}
