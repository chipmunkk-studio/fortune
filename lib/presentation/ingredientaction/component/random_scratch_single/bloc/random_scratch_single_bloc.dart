import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'random_scratch_single.dart';

class RandomScratchSingleBloc extends Bloc<RandomScratchSingleEvent, RandomScratchSingleState>
    with SideEffectBlocMixin<RandomScratchSingleEvent, RandomScratchSingleState, RandomScratchSingleSideEffect> {
  static const tag = "[RandomScratchSingleBloc]";

  RandomScratchSingleBloc() : super(RandomScratchSingleState.initial()) {
    on<RandomScratchSingleEnd>(scratchEnd);
    on<RandomScratchSingleInit>(init);
  }

  FutureOr<void> init(RandomScratchSingleInit event, Emitter<RandomScratchSingleState> emit) {
    emit(
      state.copyWith(
        randomScratchIngredients: event.randomNormalIngredients,
        randomScratchSelected: event.randomNormalSelected,
        isLoading: false,
      ),
    );
  }

  FutureOr<void> scratchEnd(RandomScratchSingleEnd event, Emitter<RandomScratchSingleState> emit) {
    emit(state.copyWith(thresholdReached: true));
    produceSideEffect(RandomScratchSingleProgressEnd(state.randomScratchSelected));
  }
}
