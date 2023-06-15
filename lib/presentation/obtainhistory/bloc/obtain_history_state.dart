import 'package:foresh_flutter/domain/supabase/entity/obtain_history_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'obtain_history_state.freezed.dart';

@freezed
class ObtainHistoryState with _$ObtainHistoryState {
  factory ObtainHistoryState({
    required List<ObtainHistoryPagingViewItem> histories,
    required int start,
    required int end,
    required String query,
    required bool isLoading,
    required bool isNextPageLoading,
  }) = _ObtainHistoryState;

  factory ObtainHistoryState.initial() => ObtainHistoryState(
        histories: List.empty(),
        start: 0,
        end: 30,
        query: '',
        isLoading: true,
        isNextPageLoading: false,
      );
}
