import 'package:fortune/domain/supabase/entity/common/notices_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notices_state.freezed.dart';

@freezed
class NoticesState with _$NoticesState {
  factory NoticesState({
    required List<NoticesEntity> items,
    required bool isLoading,
  }) = _NoticesState;

  factory NoticesState.initial() => NoticesState(
        items: List.empty(),
        isLoading: true,
      );
}
