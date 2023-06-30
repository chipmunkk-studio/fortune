import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/request/request_user_notices_update.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_notices_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_level_or_grade_up_param.dart';

class LevelOrGradeUpUseCase implements UseCase1<UserNoticeType, RequestLevelOrGradeUpParam> {
  final UserNoticesRepository userNoticesRepository;

  LevelOrGradeUpUseCase({
    required this.userNoticesRepository,
  });

  @override
  Future<FortuneResult<UserNoticeType>> call(RequestLevelOrGradeUpParam param) async {
    try {
      final prev = param.prevUser;
      final next = param.nextUser;

      if (prev.level == next.level) {
        return const Right(UserNoticeType.none);
      } else {
        if (prev.grade.name != next.grade.name) {
          return updateUserNotice(
            prev: prev,
            type: UserNoticeType.grade_up,
            title: "등급 업을 축하합니다!!",
            content: "${prev.grade.name}에서 ${next.grade.name}으로!!",
            rewardTicket: 10,
          );
        } else {
          return updateUserNotice(
            prev: prev,
            type: UserNoticeType.level_up,
            title: "레벨 업을 축하합니다!!",
            content: "${prev.level}에서 ${next.level}으로!!",
            rewardTicket: 5,
          );
        }
      }
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }

  Future<Either<FortuneFailure, UserNoticeType>> updateUserNotice({
    required FortuneUserEntity prev,
    required UserNoticeType type,
    required String title,
    required String content,
    required int rewardTicket,
  }) async {
    try {
      await userNoticesRepository.insertNotice(
        RequestUserNoticesUpdate(
          title: title,
          content: content,
          type: type.name,
          userId: prev.id,
          rewardTicket: rewardTicket,
        ),
      );
      return Right(type);
    } on FortuneFailure catch (e) {
      rethrow;
    }
  }
}
