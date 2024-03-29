import 'package:fortune/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_feed_state.freezed.dart';

@freezed
class AlarmFeedState with _$AlarmFeedState {
  factory AlarmFeedState({
    required List<AlarmFeedsEntity> feeds,
    required bool isLoading,
    required bool isReceiving,
  }) = _AlarmFeedState;

  factory AlarmFeedState.initial([
    List<AlarmFeedsEntity>? feeds,
    bool? isLoading,
    bool? isReceiving,
  ]) =>
      AlarmFeedState(
        feeds: feeds ?? List.empty(),
        isLoading: isLoading ?? true,
        isReceiving: isReceiving ?? false,
      );
}
