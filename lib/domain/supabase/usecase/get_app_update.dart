import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/support/app_update_view_entity.dart';
import 'package:fortune/domain/supabase/repository/support_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GetAppUpdate implements UseCase0<void> {
  final SupportRepository supportRepository;

  GetAppUpdate({
    required this.supportRepository,
  });

  @override
  Future<FortuneResultDeprecated<AppUpdateViewEntity>> call() async {
    try {
      final appUpdates = await supportRepository.getAppUpdateRecently();

      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String versionName = packageInfo.version; // 1.1.1
      int versionCode = int.parse(packageInfo.buildNumber); // 20

      if (appUpdates.isNotEmpty) {
        final item = appUpdates.first;
        final isActive = () {
          if (Platform.isAndroid) {
            return item.android && item.isActive;
          } else {
            return item.ios && item.isActive;
          }
        }();

        final isForceUpdate = () {
          if (Platform.isAndroid) {
            return isVersionLower(versionName, item.minVersion);
          } else {
            return versionCode < item.minVersionCode;
          }
        }();

        FortuneLogger.info(
          'Platform:: ${Platform.isIOS ? 'IOS' : 'Android'} \n'
          'currentVersion: $versionName, minVersion: ${item.minVersion} \n'
          'currentVersionCode: $versionCode, minVersionCode: ${item.minVersionCode} \n'
          'isForeUpdate: $isForceUpdate\n',
        );

        return Right(
          AppUpdateViewEntity(
            title: item.title,
            content: item.content,
            landingRoute: item.landingRoute,
            isActive: isActive,
            isForceUpdate: isForceUpdate,
            isAlert: item.isAlert,
          ),
        );
      }
      return Right(AppUpdateViewEntity.empty);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }

  bool isVersionLower(String currentVersion, String newVersion) {
    List<int> currentParts = currentVersion.split('.').map(int.parse).toList();
    List<int> newParts = newVersion.split('.').map(int.parse).toList();

    // 각 세그먼트를 비교
    for (int i = 0; i < currentParts.length; i++) {
      // 새 버전에 세그먼트가 더 많은 경우, 현재 버전이 낮음
      if (i >= newParts.length) {
        return false;
      }

      // 세그먼트 비교
      if (currentParts[i] < newParts[i]) {
        return true; // 현재 버전이 낮음
      } else if (currentParts[i] > newParts[i]) {
        return false; // 현재 버전이 높음
      }
    }

    // 모든 세그먼트가 같은 경우, 새 버전에 세그먼트가 더 많으면 현재 버전이 낮음
    return currentParts.length < newParts.length;
  }
}
