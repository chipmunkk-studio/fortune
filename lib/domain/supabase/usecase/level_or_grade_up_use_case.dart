import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_notices.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_notices_response.dart';
import 'package:foresh_flutter/domain/supabase/repository/event_notices_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_level_or_grade_up_param.dart';

class LevelOrGradeUpUseCase implements UseCase1<EventNoticesEntity?, RequestLevelOrGradeUpParam> {
  final EventNoticesRepository userNoticesRepository;

  LevelOrGradeUpUseCase({
    required this.userNoticesRepository,
  });

  @override
  Future<FortuneResult<EventNoticesEntity?>> call(RequestLevelOrGradeUpParam param) async {
    try {
      final prev = param.prevUser;
      final next = param.nextUser;
      if (prev.level != next.level) {
        if (prev.grade.name != next.grade.name) {
          return insertUserNotice(
            RequestEventNotices.insert(
              users: prev.id,
              type: EventNoticeType.user.name,
              headings: "등급 업을 축하합니다!!",
              content: "${prev.grade.name}에서 ${next.grade.name}으로!!",
              isRead: false,
              isReceived: false,
            ),
          );
        } else {
          return insertUserNotice(
            RequestEventNotices.insert(
              users: prev.id,
              type: EventNoticeType.user.name,
              headings: "레벨 업을 축하합니다!!",
              content: "${prev.level}에서 ${next.level}으로!!",
              isRead: false,
              isReceived: false,
            ),
          );
        }
      }
      return const Right(null);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }

  Future<Either<FortuneFailure, EventNoticesEntity>> insertUserNotice(
    RequestEventNotices request,
  ) async {
    try {
      return Right(await userNoticesRepository.insertNotice(request));
    } on FortuneFailure catch (e) {
      rethrow;
    }
  }
}
