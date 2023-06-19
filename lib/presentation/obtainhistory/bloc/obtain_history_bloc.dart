import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/supabase/entity/obtain_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/request/request_obtain_histories_param.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_obtain_histories_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'obtain_history.dart';

class ObtainHistoryBloc extends Bloc<ObtainHistoryEvent, ObtainHistoryState>
    with SideEffectBlocMixin<ObtainHistoryEvent, ObtainHistoryState, ObtainHistorySideEffect> {
  static const tag = "[CountryCodeBloc]";

  GetObtainHistoriesUseCase getObtainHistoriesUseCase;

  ObtainHistoryBloc({
    required this.getObtainHistoriesUseCase,
  }) : super(ObtainHistoryState.initial()) {
    on<ObtainHistoryInit>(init);
    on<ObtainHistoryNextPage>(
      nextPage,
      transformer: throttle(const Duration(seconds: 1)),
    );
    on<ObtainHistorySearchText>(
      searchText,
      transformer: debounce(
        const Duration(
          milliseconds: 200,
        ),
      ),
    );
  }

  FutureOr<void> init(ObtainHistoryInit event, Emitter<ObtainHistoryState> emit) async {
    await _getHistories(
      emit,
      query: event.searchText,
    );
    produceSideEffect(ObtainHistoryInitSearchText(event.searchText));
  }

  FutureOr<void> nextPage(ObtainHistoryNextPage event, Emitter<ObtainHistoryState> emit) async {
    if (!state.isNextPageLoading) {
      emit(
        state.copyWith(
          histories: [...state.histories, ObtainHistoryLoadingViewItem()],
          isNextPageLoading: true,
        ),
      );

      final nextStart = state.start + 20;
      final nextEnd = state.end + 20;
      final nextQuery = state.query;

      await getObtainHistoriesUseCase(
        RequestObtainHistoriesParam(
          start: nextStart,
          end: nextEnd,
          query: nextQuery,
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
            produceSideEffect(ObtainHistoryError(l));
          },
          (r) async {
            // 뷰스테이트가 로딩 상태로 바뀌기 전까지 1초정도 딜레이를 줌.
            final filteredItems = state.histories.whereNot((item) => item is ObtainHistoryLoadingViewItem).toList();
            await Future.delayed(const Duration(milliseconds: 200));
            emit(
              state.copyWith(
                histories: List.of(filteredItems)..addAll(r),
                start: r.isEmpty ? state.start : nextStart,
                end: r.isEmpty ? state.end : nextEnd,
                isLoading: false,
                isNextPageLoading: false,
              ),
            );
          },
        ),
      );
    }
  }

  FutureOr<void> searchText(ObtainHistorySearchText event, Emitter<ObtainHistoryState> emit) async {
    await _getHistories(emit, query: event.text);
  }

  _getHistories(
    Emitter<ObtainHistoryState> emit, {
    required String query,
  }) async {
    await getObtainHistoriesUseCase(
      RequestObtainHistoriesParam(
        start: 0,
        end: 19,
        query: query,
      ),
    ).then(
      (value) => value.fold(
        (l) => produceSideEffect(ObtainHistoryError(l)),
        (r) {
          emit(
            state.copyWith(
              isLoading: false,
              histories: r,
              query: query,
            ),
          );
        },
      ),
    );
  }
}
