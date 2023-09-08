import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/domain/supabase/usecase/get_my_ingredients_use_case.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'my_ingredients.dart';

class MyIngredientsBloc extends Bloc<MyIngredientsEvent, MyIngredientsState>
    with SideEffectBlocMixin<MyIngredientsEvent, MyIngredientsState, MyIngredientsSideEffect> {
  final GetMyIngredientsUseCase getMyIngredientsUseCase;

  MyIngredientsBloc({
    required this.getMyIngredientsUseCase,
  }) : super(MyIngredientsState.initial()) {
    on<MyIngredientsInit>(init);
  }

  FutureOr<void> init(MyIngredientsInit event, Emitter<MyIngredientsState> emit) async {
    await getMyIngredientsUseCase().then(
      (value) => value.fold(
        (l) => produceSideEffect(MyIngredientsError(l)),
        (r) {
          emit(
            state.copyWith(
              entities: r,
              isLoading: false,
            ),
          );
        },
      ),
    );
  }
}
