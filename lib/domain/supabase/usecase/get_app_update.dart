import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/support/app_update_view_entity.dart';
import 'package:fortune/domain/supabase/repository/support_repository.dart';

class GetAppUpdate implements UseCase0<void> {
  final SupportRepository supportRepository;

  GetAppUpdate({
    required this.supportRepository,
  });

  @override
  Future<FortuneResult<AppUpdateViewEntity?>> call() async {
    try {
      final appUpdates = await supportRepository.getAppUpdateRecently();
      if (appUpdates.isNotEmpty) {
        final item = appUpdates.first;
        final isActive = () {
          if (Platform.isAndroid) {
            return item.android && item.isActive;
          } else {
            return item.ios && item.isActive;
          }
        }();
        return Right(
          AppUpdateViewEntity(
            title: item.title,
            content: item.content,
            isActive: isActive,
          ),
        );
      }
      return const Right(null);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
