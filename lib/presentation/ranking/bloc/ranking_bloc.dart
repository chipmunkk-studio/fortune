import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/entity/ranking_view_item_entity.dart';
import 'package:fortune/domain/supabase/request/request_get_all_users_param.dart';
import 'package:fortune/domain/supabase/usecase/ranking_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'ranking.dart';

class RankingBloc extends Bloc<RankingEvent, RankingState>
    with SideEffectBlocMixin<RankingEvent, RankingState, RankingSideEffect> {
  final RankingUseCase rankingUseCase;

  RankingBloc({
    required this.rankingUseCase,
  }) : super(RankingState.initial()) {
    on<RankingInit>(init);
    on<RankingNextPage>(
      _nextPage,
      transformer: throttle(const Duration(seconds: 1)),
    );
  }

  FutureOr<void> init(RankingInit event, Emitter<RankingState> emit) async {
    await _getRanking(
      emit,
      start: 0,
      end: 30,
      type: RankingFilterType.user,
      isFirstCall: true,
    );
  }

  _getRanking(
    Emitter<RankingState> emit, {
    bool isFirstCall = false,
    required int start,
    required int end,
    required RankingFilterType type,
  }) async {
    await rankingUseCase(
      RequestRankingParam(
        start: start,
        end: end,
        type: type,
      ),
    ).then(
      (value) => value.fold(
        (l) {
          emit(
            state.copyWith(
              isLoading: false,
              isNextPageLoading: false,
            ),
          );
          produceSideEffect(RankingError(l));
        },
        (r) async {
          final filteredItems = state.rankingItems
              .whereNot(
                (item) => item is RankingPagingLoadingViewItemEntity,
              )
              .toList();

          if (!isFirstCall) {
            await Future.delayed(const Duration(milliseconds: 200));
          }

          emit(
            state.copyWith(
              rankingItems: List.of(filteredItems)..addAll(r.rankingItems),
              start: r.rankingItems.isEmpty ? state.start : start,
              end: r.rankingItems.isEmpty ? state.end : end,
              me: r.myRanking,
              isLoading: false,
              isNextPageLoading: false,
            ),
          );
        },
      ),
    );
  }

  FutureOr<void> _nextPage(RankingNextPage event, Emitter<RankingState> emit) async {
    if (!state.isNextPageLoading) {
      emit(
        state.copyWith(
          rankingItems: [...state.rankingItems, RankingPagingLoadingViewItemEntity()],
          isNextPageLoading: true,
        ),
      );
    }
    await _getRanking(
      emit,
      start: state.start + 30,
      end: state.end + 30,
      type: state.filterType,
    );
  }
}
