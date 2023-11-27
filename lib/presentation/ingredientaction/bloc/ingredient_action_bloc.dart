import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/usecase/get_ingredients_by_type_use_case.dart';
import 'package:fortune/domain/supabase/usecase/set_show_ad_use_case.dart';
import 'package:fortune/env.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'ingredient_action.dart';

class IngredientActionBloc extends Bloc<IngredientActionEvent, IngredientActionState>
    with SideEffectBlocMixin<IngredientActionEvent, IngredientActionState, IngredientActionSideEffect> {
  final SetShowAdUseCase setShowAdUseCase;
  final GetIngredientsByTypeUseCase getIngredientsByTypeUseCase;
  final Environment env;

  IngredientActionBloc({
    required this.setShowAdUseCase,
    required this.getIngredientsByTypeUseCase,
    required this.env,
  }) : super(IngredientActionState.initial()) {
    on<IngredientActionInit>(init);
    on<IngredientActionShowAdCounting>(showAdProcess);
  }

  FutureOr<void> init(IngredientActionInit event, Emitter<IngredientActionState> emit) async {
    emit(
      state.copyWith(
        entity: event.param,
        adMobStatus: env.remoteConfig.admobStatus,
      ),
    );
    await _processIngredientAction(event, emit);
  }

  _processIngredientAction(
    IngredientActionInit event,
    Emitter<IngredientActionState> emit,
  ) async {
    switch (event.param.ingredient.type) {
      // 랜덤 노말 일 경우.
      case IngredientType.randomScratchSingle:
        await processRandomNormalIngredient(event.param, emit);
        break;
      // 코인 일 경우.
      case IngredientType.coin:
        await processCoinIngredient(event.param, emit);
        break;
      // 노말/스페셜(서버 컨트롤) 일 경우 그냥 획득.
      case IngredientType.normal:
      case IngredientType.special:
        emit(state.copyWith(isLoading: false));
        produceSideEffect(IngredientProcessObtainAction(ingredient: event.param.ingredient, result: true));
        break;
      default:
        break;
    }
  }

  // 코인 일 경우.
  Future<void> processCoinIngredient(IngredientActionParam param, Emitter<IngredientActionState> emit) async {
    emit(state.copyWith(isLoading: false));
    if (param.isShowAd) {
      // 광고를 봐야할 경우.
      produceSideEffect(IngredientProcessShowAdAction(param, state.adMobStatus));
    } else {
      // 광고를 안봐도 될 경우.
      add(IngredientActionShowAdCounting());
    }
  }

  // 랜덤노말 타입 일 경우.
  Future<void> processRandomNormalIngredient(
    IngredientActionParam param,
    Emitter<IngredientActionState> emit,
  ) async {
    /// 노말과 랜덤 스크래치(싱글)만 골라옴.
    final result = await getIngredientsByTypeUseCase([
      IngredientType.normal,
      IngredientType.randomScratchSingleOnly,
    ]);
    result.fold(
      (failure) => produceSideEffect(IngredientActionError(failure)), // 에러 처리 추가
      (ingredients) {
        if (ingredients.isNotEmpty) {
          List<IngredientEntity> randomNormalIngredients = [];
          for (var ingredient in ingredients) {
            randomNormalIngredients.add(ingredient);
            if (ingredient.type == IngredientType.normal) {
              randomNormalIngredients.add(ingredient);
            }
          }
          // 노말 타입만 2배로 늘림.
          final randomIndex = math.Random().nextInt(randomNormalIngredients.length);
          final nextParam = param.copyWith(
            ingredient: randomNormalIngredients[randomIndex].copyWith(
              distance: param.ingredient.distance,
              rewardTicket: param.ingredient.rewardTicket,
              type: param.ingredient.type,
            ),
          );
          emit(
            state.copyWith(
              randomScratcherSelected: nextParam,
              randomScratchersItems: randomNormalIngredients,
              isLoading: false,
            ),
          );
        }
      },
    );
  }

  FutureOr<void> showAdProcess(IngredientActionShowAdCounting event, Emitter<IngredientActionState> emit) async {
    await setShowAdUseCase().then(
      (value) => value.fold(
        (l) => null,
        (r) => produceSideEffect(
          IngredientProcessObtainAction(
            ingredient: state.entity.ingredient,
            result: true,
          ),
        ),
      ),
    );
  }
}
