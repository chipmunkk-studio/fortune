import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'random_scratch_single.dart';

class RandomScratchSingleBloc extends Bloc<RandomScratchSingleEvent, RandomScratchSingleState>
    with SideEffectBlocMixin<RandomScratchSingleEvent, RandomScratchSingleState, RandomScratchSingleSideEffect> {
  static const tag = "[RandomScratchSingleBloc]";

  RandomScratchSingleBloc() : super(RandomScratchSingleState.initial()) {
    on<RandomScratchSingleInit>(init);
    on<RandomScratchSingleEnd>(
      scratchEnd,
      transformer: throttle(
        const Duration(seconds: 3),
      ),
    );
  }

  FutureOr<void> init(RandomScratchSingleInit event, Emitter<RandomScratchSingleState> emit) {
    emit(
      state.copyWith(
        scratchCoverEntity: event.scratchCoverEntity,
        pickedItemEntity: event.pickedItemEntity,
        isLoading: false,
      ),
    );
  }

  FutureOr<void> scratchEnd(RandomScratchSingleEnd event, Emitter<RandomScratchSingleState> emit) {
    emit(state.copyWith(thresholdReached: true));
    produceSideEffect(RandomScratchSingleProgressEnd(state.pickedItemEntity));
  }
}
