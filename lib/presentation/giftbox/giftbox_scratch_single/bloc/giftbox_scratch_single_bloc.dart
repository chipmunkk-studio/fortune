import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'giftbox_scratch_single.dart';

class GiftboxScratchSingleBloc extends Bloc<GiftboxScratchSingleEvent, GiftboxScratchSingleState>
    with SideEffectBlocMixin<GiftboxScratchSingleEvent, GiftboxScratchSingleState, GiftboxScratchSingleSideEffect> {
  static const tag = "[GiftboxScratchSingleBloc]";

  GiftboxScratchSingleBloc() : super(GiftboxScratchSingleState.initial()) {
    on<GiftboxScratchSingleInit>(init);
    on<GiftboxScratchSingleEnd>(
      scratchEnd,
      transformer: throttle(
        const Duration(seconds: 3),
      ),
    );
  }

  FutureOr<void> init(GiftboxScratchSingleInit event, Emitter<GiftboxScratchSingleState> emit) {
    emit(
      state.copyWith(
        randomScratchIngredients: event.randomNormalIngredients,
        randomScratchSelected: event.randomNormalSelected,
        isLoading: false,
      ),
    );
  }

  FutureOr<void> scratchEnd(GiftboxScratchSingleEnd event, Emitter<GiftboxScratchSingleState> emit) {
    emit(state.copyWith(thresholdReached: true));
    produceSideEffect(GiftboxScratchSingleProgressEnd(state.randomScratchSelected));
  }
}
