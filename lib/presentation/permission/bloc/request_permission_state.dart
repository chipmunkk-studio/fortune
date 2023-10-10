import 'dart:io';

import 'package:fortune/core/util/permission.dart';
import 'package:fortune/fortune_router.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'request_permission_state.freezed.dart';

@freezed
class RequestPermissionState with _$RequestPermissionState {
  factory RequestPermissionState({
    required List<Permission> permissions,
    required String nextLandingRoute,
  }) = _RequestPermissionState;

  factory RequestPermissionState.initial([
    String? nextLandingRoute,
  ]) =>
      RequestPermissionState(
        permissions:
            Platform.isAndroid ? FortunePermissionUtil.androidPermissions : FortunePermissionUtil.iosPermissions,
        // 권한확인 > 로그인으로 무조건 보냄.
        // 사용 중에 권한 해지 시에도 리프레시 할 겸 다시 로그인 하라고 함.
        nextLandingRoute: nextLandingRoute ?? Routes.loginRoute,
      );
}
