import 'package:foresh_flutter/domain/entities/main_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fortune_history_state.freezed.dart';

@freezed
class FortuneHistoryState with _$FortuneHistoryState {
  factory FortuneHistoryState({
    required List<MainHistoryEntity> histories,
  }) = _FortuneHistoryState;

  factory FortuneHistoryState.initial() => FortuneHistoryState(
    histories: List.empty(),
  );
}
