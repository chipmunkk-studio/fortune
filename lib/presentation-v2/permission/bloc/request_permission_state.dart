import 'dart:io';

import 'package:fortune/core/util/permission.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'request_permission_state.freezed.dart';

@freezed
class RequestPermissionState with _$RequestPermissionState {
  factory RequestPermissionState({
    required List<Permission> permissions,
  }) = _RequestPermissionState;

  factory RequestPermissionState.initial([
    String? nextLandingRoute,
  ]) =>
      RequestPermissionState(
        permissions:
            Platform.isAndroid ? FortunePermissionUtil.androidPermissions : FortunePermissionUtil.iosPermissions,
      );
}
