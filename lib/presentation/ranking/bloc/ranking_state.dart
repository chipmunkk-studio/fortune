import 'package:fortune/domain/supabase/entity/ranking_view_item_entity.dart';
import 'package:fortune/domain/supabase/request/request_get_all_users_param.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking_state.freezed.dart';

@freezed
class RankingState with _$RankingState {
  factory RankingState({
    required List<RankingPagingViewItem> rankingItems,
    required RankingMyRankingViewItem me,
    required bool isLoading,
    required int start,
    required int end,
    required bool isNextPageLoading,
    required RankingFilterType filterType,
  }) = _RankingState;

  factory RankingState.initial() => RankingState(
        rankingItems: List.empty(),
        me: RankingMyRankingViewItem.empty(),
        isLoading: true,
        start: 0,
        end: 30,
        isNextPageLoading: false,
        filterType: RankingFilterType.user,
      );
}
