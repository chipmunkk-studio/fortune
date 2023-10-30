import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_page_state.freezed.dart';

@freezed
class MyPageState with _$MyPageState {
  factory MyPageState({
    required FortuneUserEntity user,
    required bool isAllowPushAlarm,
    required bool isLoading,
    required bool hasNewNotice,
    required bool hasNewFaq,
  }) = _MyPageState;

  factory MyPageState.initial([
    FortuneUserEntity? user,
    bool? isAllowPushAlarm,
    bool? isLoading,
    bool? hasNewNotice,
    bool? hasNewFaq,
  ]) =>
      MyPageState(
        user: user ?? FortuneUserEntity.empty(),
        isAllowPushAlarm: isAllowPushAlarm ?? false,
        isLoading: isLoading ?? true,
        hasNewNotice: hasNewNotice ?? false,
        hasNewFaq: hasNewFaq ?? false,
      );
}
