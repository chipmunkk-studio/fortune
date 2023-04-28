import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/presentation/history/mock_data.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'marker_history.dart';

class MarkerHistoryBloc extends Bloc<MarkerHistoryEvent, MarkerHistoryState>
    with SideEffectBlocMixin<MarkerHistoryEvent, MarkerHistoryState, MarkerHistorySideEffect> {
  static const tag = "[CountryCodeBloc]";

  MarkerHistoryBloc() : super(MarkerHistoryState.initial()) {
    on<MarkerHistoryInit>(init);
    on<MarkerHistoryNextPage>(nextPage, transformer: throttle(const Duration(seconds: 1)));
  }

  FutureOr<void> init(MarkerHistoryInit event, Emitter<MarkerHistoryState> emit) async {
    emit(
      state.copyWith(
        histories: historySampleList,
      ),
    );
  }

  FutureOr<void> nextPage(MarkerHistoryNextPage event, Emitter<MarkerHistoryState> emit) {
    // todo  로딩이거나 에러가 아닐 경우에만 수행.
    FortuneLogger.debug("마지막");
  }
}
