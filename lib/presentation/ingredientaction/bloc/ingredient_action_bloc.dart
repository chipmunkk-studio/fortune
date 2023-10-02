import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/domain/supabase/usecase/set_show_ad_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'ingredient_action.dart';

class IngredientActionBloc extends Bloc<IngredientActionEvent, IngredientActionState>
    with SideEffectBlocMixin<IngredientActionEvent, IngredientActionState, IngredientActionSideEffect> {
  final SetShowAdUseCase setShowAdUseCase;

  IngredientActionBloc({
    required this.setShowAdUseCase,
  }) : super(IngredientActionState.initial()) {
    on<IngredientActionInit>(init);
    on<IngredientActionShowAdCounting>(showAdComplete);
  }

  FutureOr<void> init(IngredientActionInit event, Emitter<IngredientActionState> emit) async {
    emit(state.copyWith(entity: event.param));
    produceSideEffect(IngredientProcessAction(event.param));
  }

  FutureOr<void> showAdComplete(IngredientActionShowAdCounting event, Emitter<IngredientActionState> emit) async {
    await setShowAdUseCase().then(
      (value) => value.fold(
        (l) => null,
        (r) => produceSideEffect(IngredientAdShowComplete()),
      ),
    );
  }
}
