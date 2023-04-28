import 'package:foresh_flutter/domain/entities/main_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'marker_history_state.freezed.dart';

@freezed
class MarkerHistoryState with _$MarkerHistoryState {
  factory MarkerHistoryState({
    required List<MainHistoryEntity> histories,
  }) = _MarkerHistoryState;

  factory MarkerHistoryState.initial() => MarkerHistoryState(
    histories: List.empty(),
      );
}
