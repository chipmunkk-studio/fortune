import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'ingredient_action.dart';

class IngredientActionBloc extends Bloc<IngredientActionEvent, IngredientActionState>
    with SideEffectBlocMixin<IngredientActionEvent, IngredientActionState, IngredientActionSideEffect> {
  IngredientActionBloc() : super(IngredientActionState.initial()) {
    on<IngredientActionInit>(init);
  }

  FutureOr<void> init(IngredientActionInit event, Emitter<IngredientActionState> emit) async {
    emit(state.copyWith(entity: event.param));
    produceSideEffect(IngredientProcesAction(event.param));
  }
}
