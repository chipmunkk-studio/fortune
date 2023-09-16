import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'grade_guide_state.freezed.dart';

@freezed
class GradeGuideState with _$GradeGuideState {
  factory GradeGuideState({
    required FortuneUserEntity user,
  }) = _GradeGuideState;

  factory GradeGuideState.initial([
    FortuneUserEntity? user,
    bool? isAllowPushAlarm,
    bool? isLoading,
  ]) =>
      GradeGuideState(
        user: user ?? FortuneUserEntity.empty(),
      );
}
