import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/usecase/get_ingredients_by_type_use_case.dart';
import 'package:fortune/domain/supabase/usecase/set_show_ad_use_case.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'ingredient_action.dart';

class IngredientActionBloc extends Bloc<IngredientActionEvent, IngredientActionState>
    with SideEffectBlocMixin<IngredientActionEvent, IngredientActionState, IngredientActionSideEffect> {
  final SetShowAdUseCase setShowAdUseCase;
  final GetIngredientsByTypeUseCase getIngredientsByTypeUseCase;

  IngredientActionBloc({
    required this.setShowAdUseCase,
    required this.getIngredientsByTypeUseCase,
  }) : super(IngredientActionState.initial()) {
    on<IngredientActionInit>(init);
    on<IngredientActionShowAdCounting>(showAdComplete);
  }

  FutureOr<void> init(IngredientActionInit event, Emitter<IngredientActionState> emit) async {
    switch (event.param.ingredient.type) {
      case IngredientType.randomNormal:
        await processRandomNormalIngredient(event.param, emit);
        break;
      default:
        _emitProcessAction(event.param, emit);
        break;
    }
  }

  // 랜덤노말 타입 일 경우.
  Future<void> processRandomNormalIngredient(IngredientActionParam param, Emitter<IngredientActionState> emit) async {
    final result = await getIngredientsByTypeUseCase([
      IngredientType.normal,
      IngredientType.normalNotProvide,
    ]);
    result.fold(
      (failure) => produceSideEffect(IngredientActionError(failure)), // 에러 처리 추가
      (ingredients) {
        if (ingredients.isNotEmpty) {
          List<IngredientEntity> finalResult = [];
          for (var ingredient in ingredients) {
            finalResult.add(ingredient);
            if (ingredient.type == IngredientType.normal) {
              finalResult.add(ingredient);
            }
          }
          // 노말 타입만 2배로 늘림.
          final randomIndex = math.Random().nextInt(finalResult.length);
          final nextParam = param.copyWith(
            ingredient: finalResult[randomIndex].copyWith(
              distance: param.ingredient.distance,
              rewardTicket: param.ingredient.rewardTicket,
              type: param.ingredient.type,
            ),
          );
          _emitProcessAction(nextParam, emit);
        }
      },
    );
  }

  _emitProcessAction(
    IngredientActionParam param,
    Emitter<IngredientActionState> emit,
  ) {
    emit(state.copyWith(entity: param));
    produceSideEffect(IngredientProcessAction(param));
  }

  FutureOr<void> showAdComplete(IngredientActionShowAdCounting event, Emitter<IngredientActionState> emit) async {
    await setShowAdUseCase().then(
      (value) => value.fold(
        (l) => null,
        (r) => produceSideEffect(
          IngredientAdShowComplete(
            ingredient: state.entity.ingredient,
            result: true,
          ),
        ),
      ),
    );
  }
}
