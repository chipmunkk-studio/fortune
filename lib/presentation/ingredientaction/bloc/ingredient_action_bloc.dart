import 'dart:async';
import 'dart:math' as math;

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/usecase/get_ingredients_by_type_use_case.dart';
import 'package:fortune/domain/supabase/usecase/reduce_coin_use_case.dart';
import 'package:fortune/domain/supabase/usecase/set_show_ad_use_case.dart';
import 'package:fortune/env.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'ingredient_action.dart';

class IngredientActionBloc extends Bloc<IngredientActionEvent, IngredientActionState>
    with SideEffectBlocMixin<IngredientActionEvent, IngredientActionState, IngredientActionSideEffect> {
  final SetShowAdUseCase setShowAdUseCase;
  final GetIngredientsByTypeUseCase getIngredientsByTypeUseCase;
  final ReduceCoinUseCase reduceCoinUseCase;
  final Environment env;

  IngredientActionBloc({
    required this.setShowAdUseCase,
    required this.reduceCoinUseCase,
    required this.getIngredientsByTypeUseCase,
    required this.env,
  }) : super(IngredientActionState.initial()) {
    on<IngredientActionInit>(init);
    on<IngredientActionShowAdCounting>(showAdProcess);
    on<IngredientActionObtainSuccess>(
      obtainSuccess,
      transformer: throttle(
        const Duration(seconds: 1),
      ),
    );
  }

  FutureOr<void> init(IngredientActionInit event, Emitter<IngredientActionState> emit) async {
    /// 광고를 봐야할 타이밍인데 광고가 없을때.
    if (event.param.isShowAd && event.param.ad == null && event.param.ingredient.type == IngredientType.coin) {
      final noAdsParam = event.param.copyWith(ad: null);
      produceSideEffect(IngredientProcessShowAdAction(noAdsParam, true));
      return;
    }

    await reduceCoinUseCase(event.param.ingredient).then(
      (value) => value.fold(
        (l) => produceSideEffect(IngredientActionError(l)),
        (r) async {
          emit(state.copyWith(adMobStatus: env.remoteConfig.admobStatus));
          await _processIngredientAction(event, emit);
        },
      ),
    );
  }

  _processIngredientAction(
    IngredientActionInit event,
    Emitter<IngredientActionState> emit,
  ) async {
    switch (event.param.ingredient.type) {
      // 랜덤 싱글/멀티 일 경우.
      case IngredientType.randomScratchSingle:
      case IngredientType.randomScratchMulti:
        await processRandomIngredient(event.param, emit);
        break;
      // 코인 일 경우.
      case IngredientType.coin:
        await processCoinIngredient(event.param, emit);
        break;
      // 노말/스페셜(서버 컨트롤) 일 경우 그냥 획득.
      case IngredientType.normal:
      case IngredientType.special:
        emit(state.copyWith(isLoading: false));
        produceSideEffect(IngredientProcessObtainAction(ingredient: event.param.ingredient));
        break;
      default:
        break;
    }
  }

  // 코인 일 경우.
  Future<void> processCoinIngredient(IngredientActionParam param, Emitter<IngredientActionState> emit) async {
    if (param.isShowAd) {
      // 광고를 봐야할 경우.
      produceSideEffect(IngredientProcessShowAdAction(param, state.adMobStatus));
    } else {
      // 광고를 안봐도 될 경우.
      add(IngredientActionShowAdCounting());
    }
    emit(
      state.copyWith(
        entity: param,
        isLoading: false,
      ),
    );
  }

  // 랜덤노말 타입 일 경우.
  Future<void> processRandomIngredient(
    IngredientActionParam param,
    Emitter<IngredientActionState> emit,
  ) async {
    /// 노말과 랜덤 스크래치(싱글)만 골라옴.
    final result = await getIngredientsByTypeUseCase([
      IngredientType.normal,
      if (param.ingredient.type == IngredientType.randomScratchSingle) IngredientType.randomScratchSingleOnly,
      if (param.ingredient.type == IngredientType.randomScratchMulti) IngredientType.randomScratchMultiOnly,
    ]);

    result.fold(
      (failure) => produceSideEffect(IngredientActionError(failure)), // 에러 처리 추가
      (ingredients) {
        if (ingredients.isNotEmpty) {
          List<IngredientEntity> randomNormalIngredients = [];
          for (var ingredient in ingredients) {
            randomNormalIngredients.add(ingredient);
            if (ingredient.type == IngredientType.normal) {
              randomNormalIngredients.addAll(
                List.generate(
                  env.remoteConfig.randomBoxProbability,
                  (index) => ingredient,
                ),
              );
            }
          }
          // 노말 타입만 env.remoteConfig.randomBoxProbability 만큼 배로 늘림.
          final randomIndex = math.Random().nextInt(randomNormalIngredients.length);
          final nextParam = param.copyWith(
            ingredient: randomNormalIngredients[randomIndex].copyWith(
              // 랜덤박스에 있는 거리 그대로 복사.
              distance: param.ingredient.distance,
              // 랜덤박스에 있는 티켓 수 복사.
              rewardTicket: param.ingredient.rewardTicket,
              // 랜덤박스의 타입 그대로 복사.
              type: param.ingredient.type,
            ),
          );
          emit(
            state.copyWith(
              entity: param,
              randomScratcherSelected: nextParam,
              randomScratchersItems: ingredients,
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
          ),
        ),
      ),
    );
  }

  FutureOr<void> obtainSuccess(IngredientActionObtainSuccess event, Emitter<IngredientActionState> emit) {
    produceSideEffect(
      IngredientProcessObtainAction(
        ingredient: event.entity,
      ),
    );
  }
}
