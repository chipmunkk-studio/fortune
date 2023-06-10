import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'reward_history.dart';

class RewardHistoryBloc extends Bloc<RewardHistoryEvent, RewardHistoryState>
    with SideEffectBlocMixin<RewardHistoryEvent, RewardHistoryState, RewardHistorySideEffect> {
  static const tag = "[CountryCodeBloc]";

  RewardHistoryBloc() : super(RewardHistoryState.initial()) {
    on<RewardHistoryInit>(init);
    on<RewardHistoryNextPage>(nextPage, transformer: throttle(const Duration(seconds: 1)));
  }

  FutureOr<void> init(RewardHistoryInit event, Emitter<RewardHistoryState> emit) async {
    // emit(
    //   state.copyWith(
    //     histories: historySampleList,
    //   ),
    // );
  }

  FutureOr<void> nextPage(RewardHistoryNextPage event, Emitter<RewardHistoryState> emit) {
    // todo  로딩이거나 에러가 아닐 경우에만 수행.
    FortuneLogger.debug("마지막");
  }
}
